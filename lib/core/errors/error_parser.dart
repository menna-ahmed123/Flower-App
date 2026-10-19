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
  // ignore: avoid_print
  print('🔴 DioException: type=${exception.type} | message=${exception.message} | error=${exception.error} | uri=${exception.requestOptions.uri}');
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
  final raw = exception.response?.data;
  final data = raw is Map ? Map<String, dynamic>.from(raw) : null;
  if (data != null) {
    final payload = _mapOrNull(data['data']);
    final code =
        _errorCode(payload) ??
        _errorCode(data) ??
        _envelopeErrorCode(data['errors']);
    final fieldErrors =
        fieldErrorsMessage(_asErrorMap(data['errors'])) ??
        fieldErrorsMessage(_validationFieldErrors(payload));
    if (fieldErrors != null) {
      return BadResponseError(fieldErrors, code: code, data: payload);
    }
    if (data['message'] != null) {
      return BadResponseError(
        data['message'].toString(),
        code: code,
        data: payload,
      );
    }
    if (data['error'] != null) {
      return BadResponseError(
        data['error'].toString(),
        code: code,
        data: payload,
      );
    }
    if (code != null) {
      return BadResponseError(
        statusCodeToMessage(exception.response?.statusCode),
        code: code,
        data: payload,
      );
    }
  }
  if (exception.response?.statusCode == 401) return UnauthorizedError();
  return BadResponseError(statusCodeToMessage(exception.response?.statusCode));
}

Map<String, dynamic>? _mapOrNull(dynamic raw) {
  if (raw is! Map) return null;
  return Map<String, dynamic>.from(raw);
}

String? _errorCode(Map<String, dynamic>? raw) {
  final code = raw?['code'];
  if (code is! String || code.isEmpty) return null;
  return code;
}

/// Orders and cart failures put the business code in `errors[].field`
/// (for example `Order.NotServiceable`) while `code` stays the HTTP status.
Map<String, dynamic>? _asErrorMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

String? _envelopeErrorCode(dynamic errors) {
  if (errors is! List || errors.isEmpty) return null;
  final first = errors.first;
  if (first is! Map) return null;
  final field = first['field'];
  if (field is! String || !field.contains('.')) return null;
  return field;
}

/// Docker identity validation failures put field errors in `data`
/// (e.g. Email / PhoneNumber), not in `errors`.
Map<String, dynamic>? _validationFieldErrors(dynamic raw) {
  if (raw is! Map) return null;
  if (raw.containsKey('userId') ||
      raw.containsKey('accessToken') ||
      raw.containsKey('refreshToken') ||
      raw.containsKey('code')) {
    return null;
  }
  final map = Map<String, dynamic>.from(raw);
  if (map.isEmpty) return null;
  final looksLikeFieldErrors = map.values.every(
    (value) => value is List || value is String,
  );
  return looksLikeFieldErrors ? map : null;
}
String? fieldErrorsMessage(dynamic errors) {
  if (errors == null) return null;
  final messages = <String>[];

  if (errors is List) {
    for (final item in errors) {
      if (item is Map) {
        final msg = item['message'] ?? item['error'] ?? item['msg'];
        if (msg != null) messages.add(msg.toString());
      } else if (item != null) {
        messages.add(item.toString());
      }
    }
  } 
  else if (errors is Map) {
    for (final value in errors.values) {
      if (value is List) {
        messages.addAll(value.map((e) => e.toString()));
      } else if (value != null) {
        messages.add(value.toString());
      }
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
