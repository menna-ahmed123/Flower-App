import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String? id;
  final String? deviceName;
  final String? lastActiveAt;
  final String? approximateLocationOrIp;
  final String? expiresAt;

 const SessionEntity({
    this.id,
    this.deviceName,
    this.lastActiveAt,
    this.approximateLocationOrIp,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [
    id,
    deviceName,
    lastActiveAt,
    approximateLocationOrIp,
    expiresAt,
  ];
}