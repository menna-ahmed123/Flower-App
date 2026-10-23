import 'package:injectable/injectable.dart';
import '../../../../core/services/fcm_service.dart';
import 'order_tracking_fcm_data_source.dart';

@Injectable(as: OrderTrackingFcmDataSource)
class OrderTrackingFcmDataSourceImpl implements OrderTrackingFcmDataSource {
  const OrderTrackingFcmDataSourceImpl(this._fcmService);
  final FcmService _fcmService;

  static const String _orderIdKey = 'orderId';

  @override
  Stream<void> watchChangeSignals({required String orderId}) {
    return _fcmService.onMessage
        .where((message) => message.data[_orderIdKey]?.toString() == orderId)
        .map((_) {});
  }
}
