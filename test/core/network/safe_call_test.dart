import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flutter_test/flutter_test.dart';

// not dependencies
void main() {
  late SafeCall safeCall;
  setUpAll(() {
    safeCall = SafeCall();
  });
  group("test useCase safeCall success, error", () {
    test("should return SuccessResponse when api call success", () async {
      final result = await safeCall.safeApiCall<String>(() async => "success");
      expect(result, isA<SuccessResponse<String>>());


      final success = result as SuccessResponse<String>;
      expect(success.data, 'success');
    });
    test("should return ErrorResponse when api call error", () async {
      final result = await safeCall.safeApiCall<String>(() async {
        throw Exception('Something went wrong');
      });
      expect(result, isA<ErrorResponse<String>>());

      final error = result as ErrorResponse<String>;
      expect(error.appError, isNotNull);
    });
  });
}
