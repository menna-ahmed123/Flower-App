import 'package:dio/dio.dart';
import 'package:flower_app/core/errors/app_error.dart';
import 'package:flower_app/core/errors/error_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('surfaces Docker register field errors from data map', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/identity/users/register'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/identity/users/register'),
        statusCode: 422,
        data: {
          'data': {
            'Email': ['Email already registered'],
            'PhoneNumber': ['Phone number already registered'],
          },
          'statusCode': 422,
          'success': false,
          'message': 'Customer registration validation failed.',
        },
      ),
    );

    final error = errorParser(exception);

    expect(error, isA<BadResponseError>());
    expect(
      error.message,
      'Email already registered\nPhone number already registered',
    );
  });
}
