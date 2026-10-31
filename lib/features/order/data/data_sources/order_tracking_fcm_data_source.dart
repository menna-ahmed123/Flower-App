abstract interface class OrderTrackingFcmDataSource {
  Stream<void> watchChangeSignals({required String orderId});
}
