import 'package:equatable/equatable.dart';

class GeoPoint extends Equatable {
  const GeoPoint(this.lat, this.lng);
  final double lat;
  final double lng;

  @override
  List<Object?> get props => [lat, lng];
}
