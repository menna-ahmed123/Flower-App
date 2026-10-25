import 'package:flower_app/features/order/data/models/delivery_confirmation_model.dart';
import 'package:flower_app/features/order/domain/entities/order_status.dart';

import '../../domain/entities/delivery_confirmation_entity.dart';

extension DeliveryConfirmationMapper on DeliveryConfirmationModel {
  DeliveryConfirmationEntity toDomain() {
    return DeliveryConfirmationEntity(
      orderId: orderId ?? '',
      status: OrderStatus.fromApi(status),
      confirmedAt: confirmedAt != null ? DateTime.parse(confirmedAt!) : null,
    );
  }
}
