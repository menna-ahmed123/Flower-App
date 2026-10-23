import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/services/fcm_service.dart';
import 'package:flower_app/features/order/data/data_sources/order_tracking_fcm_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fakes the transport only: feeds controllable [RemoteMessage]s and never
/// touches the real Firebase plugin.
class _FakeFcmService implements FcmService {
  final StreamController<RemoteMessage> messages =
      StreamController<RemoteMessage>.broadcast();

  @override
  Stream<RemoteMessage> get onMessage => messages.stream;

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  void emit(Map<String, dynamic> data) => messages.add(RemoteMessage(data: data));

  Future<void> close() => messages.close();
}

void main() {
  late _FakeFcmService fcm;
  late OrderTrackingFcmDataSourceImpl source;
  const orderId = 'order-1';

  setUp(() {
    fcm = _FakeFcmService();
    source = OrderTrackingFcmDataSourceImpl(fcm);
  });

  tearDown(() async => fcm.close());

  group('watchChangeSignals', () {
    test('fires for a matching order carrying the backend summary shape',
        () async {
      final signals = <int>[];
      final sub = source
          .watchChangeSignals(orderId: orderId)
          .listen((_) => signals.add(1));

      fcm.emit({
        'orderId': orderId,
        'type': 'order_status_update',
        'oldStatus': 'PickedUp',
        'newStatus': 'OutForDelivery',
        'timestamp': '2026-10-23T00:08:51.8178138Z',
      });
      await Future<void>(() {});

      expect(signals, hasLength(1));
      await sub.cancel();
    });

    test('fires for any matching-order message regardless of payload',
        () async {
      final signals = <int>[];
      final sub = source
          .watchChangeSignals(orderId: orderId)
          .listen((_) => signals.add(1));

      fcm.emit({'orderId': orderId});
      fcm.emit({'orderId': orderId, 'message': 'Your order status changed'});
      await Future<void>(() {});

      expect(signals, hasLength(2));
      await sub.cancel();
    });

    test('stays silent for other orders', () async {
      final signals = <int>[];
      final sub = source
          .watchChangeSignals(orderId: orderId)
          .listen((_) => signals.add(1));

      fcm.emit({'orderId': 'other-order', 'type': 'order_status_update'});
      fcm.emit({'type': 'order_status_update'});
      await Future<void>(() {});

      expect(signals, isEmpty);
      await sub.cancel();
    });
  });
}
