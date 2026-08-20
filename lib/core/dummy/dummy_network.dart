/// Shared latency so dummy data sources still exercise loading UI.
abstract final class DummyNetwork {
  static const delay = Duration(milliseconds: 400);

  static Future<void> wait() => Future<void>.delayed(delay);
}
