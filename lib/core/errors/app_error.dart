abstract class AppError {
 final Exception? exception;
 final String message;
  AppError(this.exception, this.message);
}

class TimeOutError extends AppError {
  TimeOutError(Exception exception)
    : super(exception, "Connection timeout, please try again.");
}

class NoInternetError extends AppError {
  NoInternetError(Exception exception)
    : super(exception, "No internet connection, please try again.");
}

class BadCertificateError extends AppError {
  BadCertificateError(super.exception, super.message);
}

class UnauthorizedError extends AppError {
  UnauthorizedError() : super(null, "Unauthorized, please login again.");
}

class IgnoreError extends AppError {
  IgnoreError() : super(null, "Something went wrong.");
}
class ForceLogin extends AppError {
  ForceLogin()
      : super(null, "Your session has expired. Please login again.");
}

class BadResponseError extends AppError {
  BadResponseError(String message, {this.code, this.data})
    : super(null, message);

  final String? code;
  final Map<String, dynamic>? data;
}

/// Throwable wrapper that carries a typed [AppError] through APIs that only
/// surface a string (e.g. PaginationController's `e.toString()`), so the UI
/// shows the clean message and callers can still inspect the concrete error.
class AppFailure implements Exception {
  final AppError error;
  const AppFailure(this.error);

  String get message => error.message;

  @override
  String toString() => message;
}
