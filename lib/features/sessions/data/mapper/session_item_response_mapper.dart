import 'package:flower_app/features/sessions/data/models/response/session_item_response.dart';

import '../../domain/entities/session_entity.dart';

extension SessionItemResponseMapper on SessionItemResponse {
  SessionEntity toEntity() {
    return SessionEntity(
      id: id,
      deviceName: deviceName,
      lastActiveAt: lastActiveAt,
      approximateLocationOrIp: approximateLocationOrIp,
      expiresAt: expiresAt,
    );
  }
}