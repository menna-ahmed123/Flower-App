import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/order_tracking/view/extensions/tracking_date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('trackingAgoLabel', () {
    test('ages under a minute are counted in seconds', () {
      expect(const Duration(seconds: 45).trackingAgoLabel, '45s ago');
      expect(const Duration(seconds: 1).trackingAgoLabel, '1s ago');
    });

    test('ages under an hour are counted in minutes', () {
      expect(const Duration(seconds: 90).trackingAgoLabel, '1 min ago');
      expect(const Duration(minutes: 20).trackingAgoLabel, '20 min ago');
    });

    test('longer ages are counted in hours', () {
      expect(const Duration(minutes: 61).trackingAgoLabel, '1 h ago');
      expect(const Duration(hours: 5).trackingAgoLabel, '5 h ago');
    });
  });

  group('trackingPhrase', () {
    test('fills the phrase with the age it is given', () {
      expect(
        trackingPhrase(AppString.trackingUpdatedAgo, '2 min ago'),
        'Updated 2 min ago',
      );
      expect(
        trackingPhrase(AppString.trackingLocationOutdated, '3 h ago'),
        'Location outdated · 3 h ago',
      );
    });

    test('keeps the wording of the phrase, so any language can order it', () {
      // The age is dropped into a slot instead of glued between two literals.
      expect(
        trackingPhrase('{value} - check once more', '1 min ago'),
        '1 min ago - check once more',
      );
    });
  });
}
