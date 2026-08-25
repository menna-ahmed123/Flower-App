import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/app_error.dart';

AppError errorParser(Exception exception) {
  if (exception is ApiException) return _parseApiException(exception);
  if (exception is! DioException) return IgnoreError();
  if (exception.error is ForceLogin) return ForceLogin();
  return _parseDioException(exception);
}

AppError _parseApiException(ApiException exception) {
  final fieldErrors = fieldErrorsMessage(exception.errors);
  if (fieldErrors != null) return BadResponseError(fieldErrors);
  return BadResponseError(exception.message);
}

AppError _parseDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => TimeOutError(exception),
    DioExceptionType.badCertificate => BadCertificateError(
      exception,
      'Invalid certificate, please try again later.',
    ),
    DioExceptionType.badResponse => _parseBadResponse(exception),
    DioExceptionType.connectionError => _connectionError(exception),
    DioExceptionType.cancel ||
    DioExceptionType.unknown ||
    DioExceptionType.transformTimeout => IgnoreError(),
  };
}

AppError _connectionError(DioException exception) {
  final detail = '${exception.message} ${exception.error}';
  if (detail.contains('Connection refused') ||
      detail.contains('Failed host lookup') ||
      detail.contains('Network is unreachable') ||
      detail.contains('Connection reset')) {
    return BadResponseError(
      'Cannot reach the server. Start the backend with ./setup.sh and retry.',
    );
  }
  return NoInternetError(exception);
}

AppError _parseBadResponse(DioException exception) {
  final data = exception.response?.data;
  if (data is Map<String, dynamic>) {
    final fieldErrors = fieldErrorsMessage(data['errors']);
    if (fieldErrors != null) return BadResponseError(fieldErrors);
    if (data['message'] != null) {
      return BadResponseError(data['message'].toString());
    }
    if (data['error'] != null) {
      return BadResponseError(data['error'].toString());
    }
  }
  if (exception.response?.statusCode == 401) return UnauthorizedError();
  return BadResponseError(statusCodeToMessage(exception.response?.statusCode));
}

String? fieldErrorsMessage(Map<String, dynamic>? errors) {
  if (errors == null) return null;
  final messages = <String>[];
  for (final value in errors.values) {
    if (value is List) {
      messages.addAll(value.map((e) => e.toString()));
    } else if (value != null) {
      messages.add(value.toString());
    }
  }
  if (messages.isEmpty) return null;
  return messages.join('\n');
}

const Map<int, String> statusMessages = {
  400: 'Something went wrong, please try again.',
  401: 'Unauthorized, please login again.',
  403: 'You are not allowed to perform this action.',
  404: 'Resource not found.',
  409: 'Conflict occurred.',
  422: 'Validation failed.',
  429: 'Too many requests, please try again later.',
  500: 'Internal server error, please try again later.',
  502: 'Bad gateway.',
  503: 'Service unavailable.',
  504: 'Gateway timeout.',
};

String statusCodeToMessage(int? statusCode) {
  return statusMessages[statusCode] ??
      'Something went wrong, please try again.';
}
