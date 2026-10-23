import 'package:json_annotation/json_annotation.dart';

part 'order_tracking_model.g.dart';

@JsonSerializable()
class OrderTrackingModel {
  @JsonKey(name: "orderId")
  final String orderId;
  @JsonKey(name: "orderNumber")
  final String? orderNumber;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "isTrackingActive")
  final bool? isTrackingActive;
  @JsonKey(name: "timeline")
  final List<Timeline>? timeline;
  @JsonKey(name: "driver")
  final Driver? driver;
  @JsonKey(name: "lastKnownLocation")
  final LastKnownLocation? lastKnownLocation;
  @JsonKey(name: "destination")
  final Destination? destination;
  @JsonKey(name: "storeLocation")
  final StoreLocation? storeLocation;

  OrderTrackingModel ({
    required this.orderId,
    this.orderNumber,
    this.status,
    this.isTrackingActive,
    this.timeline,
    this.driver,
    this.lastKnownLocation,
    this.destination,
    this.storeLocation,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return _$OrderTrackingModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OrderTrackingModelToJson(this);
  }
}

@JsonSerializable()
class Timeline {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "isCompleted")
  final bool? isCompleted;
  @JsonKey(name: "isCurrent")
  final bool? isCurrent;
  @JsonKey(name: "occurredAt")
  final String? occurredAt;

  Timeline ({
    this.status,
    this.isCompleted,
    this.isCurrent,
    this.occurredAt,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return _$TimelineFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TimelineToJson(this);
  }
}

@JsonSerializable()
class Driver {
  @JsonKey(name: "driverId")
  final String? driverId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "assignedAt")
  final String? assignedAt;

  Driver ({
    this.driverId,
    this.name,
    this.phone,
    this.imageUrl,
    this.assignedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return _$DriverFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DriverToJson(this);
  }
}

@JsonSerializable()
class LastKnownLocation {
  @JsonKey(name: "lat")
  final double? lat;
  @JsonKey(name: "lng")
  final double? lng;
  @JsonKey(name: "recordedAt")
  final String? recordedAt;
  @JsonKey(name: "ageSeconds")
  final int? ageSeconds;
  @JsonKey(name: "isStale")
  final bool? isStale;

  LastKnownLocation ({
    this.lat,
    this.lng,
    this.recordedAt,
    this.ageSeconds,
    this.isStale,
  });

  factory LastKnownLocation.fromJson(Map<String, dynamic> json) {
    return _$LastKnownLocationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$LastKnownLocationToJson(this);
  }
}

@JsonSerializable()
class Destination {
  @JsonKey(name: "lat")
  final double? lat;
  @JsonKey(name: "lng")
  final double? lng;
  @JsonKey(name: "recipientName")
  final String? recipientName;
  @JsonKey(name: "addressLine")
  final String? addressLine;
  @JsonKey(name: "city")
  final String? city;
  @JsonKey(name: "area")
  final String? area;

  Destination ({
    this.lat,
    this.lng,
    this.recipientName,
    this.addressLine,
    this.city,
    this.area,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return _$DestinationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DestinationToJson(this);
  }
}

@JsonSerializable()
class StoreLocation {
  @JsonKey(name: "lat")
  final double? lat;
  @JsonKey(name: "lng")
  final double? lng;

  StoreLocation ({
    this.lat,
    this.lng,
  });

  factory StoreLocation.fromJson(Map<String, dynamic> json) {
    return _$StoreLocationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoreLocationToJson(this);
  }
}
