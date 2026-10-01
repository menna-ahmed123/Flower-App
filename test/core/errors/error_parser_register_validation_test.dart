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

  test('reads checkout conflict codes from data.code', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/orders/checkout'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/orders/checkout'),
        statusCode: 409,
        data: {
          'data': {'code': 'AddressRequired'},
          'statusCode': 409,
          'success': false,
          'message': 'Address is required.',
        },
      ),
    );

    final error = errorParser(exception);

    expect(error, isA<BadResponseError>());
    expect(error.message, 'Address is required.');
    expect((error as BadResponseError).code, 'AddressRequired');
  });

  test('maps checkout 422 field errors from data including dotted keys', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/orders/checkout'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/orders/checkout'),
        statusCode: 422,
        data: {
          'data': {
            'PaymentMethod': ['Choose Cash on Delivery (1) or Card (2).'],
            'Gift.Phone': [
              'Enter a valid Egyptian mobile number (01[0-2,5]XXXXXXXX).',
            ],
          },
          'statusCode': 422,
          'success': false,
          'message': 'Checkout request validation failed.',
        },
      ),
    );

    final error = errorParser(exception);

    expect(error, isA<BadResponseError>());
    expect(
      error.message,
      'Choose Cash on Delivery (1) or Card (2).\n'
      'Enter a valid Egyptian mobile number (01[0-2,5]XXXXXXXX).',
    );
    expect((error as BadResponseError).code, isNull);
  });
}
