import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/app_error.dart';

AppError errorParser(Exception exception) {
  if (exception is DioException) {
    if (exception.error is ForceLogin) {
      return ForceLogin();
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeOutError(exception);

      case DioExceptionType.badCertificate:
        return BadCertificateError(
          exception,
          "Invalid certificate, please try again later.",
        );

      case DioExceptionType.badResponse:
        final data = exception.response?.data;

        if (data is Map<String, dynamic>) {
          if (data['message'] != null) {
            return BadResponseError(data['message'].toString());
          }

          if (data['error'] != null) {
            return BadResponseError(data['error'].toString());
          }
        }

        if (exception.response?.statusCode == 401) {
          return UnauthorizedError();
        }

        return BadResponseError(
          statusCodeToMessage(exception.response?.statusCode),
        );
      case DioExceptionType.cancel:
        return IgnoreError();
      case DioExceptionType.connectionError:
        return NoInternetError(exception);
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return IgnoreError();
    }
  }
  return IgnoreError();
}

String statusCodeToMessage(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'Something went wrong, please try again.';
    case 401:
      return 'Unauthorized, please login again.';
    case 403:
      return 'You are not allowed to perform this action.';
    case 404:
      return 'Resource not found.';
    case 409:
      return 'Conflict occurred.';
    case 422:
      return 'No Data Found.';
    case 429:
      return 'Too many requests, please try again later.';
    case 500:
      return 'Internal server error, please try again later.';
    case 502:
      return 'Bad gateway.';
    case 503:
      return 'Service unavailable.';
    case 504:
      return 'Gateway timeout.';
    default:
      return 'Something went wrong, please try again.';
  }
}
