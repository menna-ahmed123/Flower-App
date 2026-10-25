import 'package:json_annotation/json_annotation.dart';

part 'osrm_route_model.g.dart';

@JsonSerializable()
class OsrmRouteModel {
  @JsonKey(name: 'code')
  final String? code;
  @JsonKey(name: 'routes')
  final List<OsrmRoute>? routes;

  const OsrmRouteModel({this.code, this.routes});

  factory OsrmRouteModel.fromJson(Map<String, dynamic> json) =>
      _$OsrmRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$OsrmRouteModelToJson(this);
}

@JsonSerializable()
class OsrmRoute {
  @JsonKey(name: 'geometry')
  final OsrmGeometry? geometry;

  const OsrmRoute({this.geometry});

  factory OsrmRoute.fromJson(Map<String, dynamic> json) =>
      _$OsrmRouteFromJson(json);

  Map<String, dynamic> toJson() => _$OsrmRouteToJson(this);
}

@JsonSerializable()
class OsrmGeometry {
  @JsonKey(name: 'type')
  final String? type;
  @JsonKey(name: 'coordinates')
  final List<List<double>>? coordinates;

  const OsrmGeometry({this.type, this.coordinates});

  factory OsrmGeometry.fromJson(Map<String, dynamic> json) =>
      _$OsrmGeometryFromJson(json);

  Map<String, dynamic> toJson() => _$OsrmGeometryToJson(this);
}
