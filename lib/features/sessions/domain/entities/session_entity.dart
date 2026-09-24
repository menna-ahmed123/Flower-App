class SessionEntity {
  final String? id;
  final String? deviceName;
  final String? lastActiveAt;
  final String? approximateLocationOrIp;
  final String? expiresAt;

  SessionEntity({
    this.id,
    this.deviceName,
    this.lastActiveAt,
    this.approximateLocationOrIp,
    this.expiresAt,
  });
}