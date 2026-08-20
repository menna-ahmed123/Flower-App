/// Dependency-injection environments used to swap data sources.
///
/// Keep [mock] while backend Auth APIs are unavailable. Switch
/// [configureDependencies] to [prod] when the real APIs are ready — UI,
/// use cases, and repositories stay unchanged.
abstract final class AppEnvironment {
  static const mock = 'mock';
  static const prod = 'prod';
}
