import 'package:flower_app/features/order/domain/entities/geo_point.dart';
import 'package:flower_app/features/order/domain/utils/geo_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('haversineDistanceMeters', () {
    test('the same point is zero distance away', () {
      const a = GeoPoint(30.05, 31.23);

      expect(haversineDistanceMeters(a, a), 0);
    });

    test('one degree of latitude is about 111 kilometres', () {
      final meters =
          haversineDistanceMeters(const GeoPoint(30, 31), const GeoPoint(31, 31));

      expect(meters, closeTo(111195, 200));
    });
  });

  group('distanceToPolylineMeters', () {
    // The same straight store->home line the view model tests use.
    const line = [GeoPoint(30.0500, 31.2300), GeoPoint(30.0600, 31.2600)];

    test('a point sitting on the line is nearly zero away', () {
      expect(
        distanceToPolylineMeters(const GeoPoint(30.0550, 31.2450), line),
        lessThan(1),
      );
    });

    test('measures the side offset from the line, not from the ends', () {
      final meters =
          distanceToPolylineMeters(const GeoPoint(30.0550, 31.2500), line);

      expect(meters, closeTo(173, 25));
    });

    test('a point past the ends falls back to the nearest endpoint', () {
      final meters =
          distanceToPolylineMeters(const GeoPoint(30.0700, 31.2700), line);

      expect(meters, closeTo(haversineDistanceMeters(
        const GeoPoint(30.0700, 31.2700),
        const GeoPoint(30.0600, 31.2600),
      ), 1));
    });

    test('a single point polyline is measured to that point', () {
      expect(
        distanceToPolylineMeters(
          const GeoPoint(30.0600, 31.2300),
          const [GeoPoint(30.0500, 31.2300)],
        ),
        closeTo(1113, 10),
      );
    });

    test('an empty polyline is infinitely far away', () {
      expect(
        distanceToPolylineMeters(const GeoPoint(30, 31), const []),
        double.infinity,
      );
    });
  });
}
