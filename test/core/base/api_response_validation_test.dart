import 'package:flower_app/core/base/api_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';

ApiResponse<String> _envelope({
  bool status = true,
  int code = 200,
  String message = 'ok',
  String? data = 'payload',
  Object? errors,
}) =>
    ApiResponse<String>(
      status: status,
      code: code,
      message: message,
      data: data,
      errors: errors,
    );

void main() {
  group('ApiResponse.dataOrThrow', () {
    test('returns the payload on a successful envelope', () {
      expect(_envelope().dataOrThrow(), 'payload');
    });

    test('throws when status is false', () {
      expect(
        () => _envelope(status: false).dataOrThrow(),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws when the data payload is missing', () {
      expect(
        () => _envelope(data: null).dataOrThrow(),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws when field errors are carried', () {
      expect(
        () => _envelope(errors: {'name': 'invalid'}).dataOrThrow(),
        throwsA(isA<ApiException>()),
      );
    });

    test('the thrown exception keeps the envelope code and message', () {
      late ApiException caught;
      try {
        _envelope(status: false, code: 422, message: 'nope').dataOrThrow();
        fail('expected ApiException to be thrown');
      } on ApiException catch (e) {
        caught = e;
      }

      expect(caught.statusCode, 422);
      expect(caught.message, 'nope');
    });
  });
}
