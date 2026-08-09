
import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/error_parser.dart';
import 'package:injectable/injectable.dart';
@injectable
class SafeCall {
  Future<BaseResponse<T>> safeApiCall<T>(
    Future<T> Function() apiCall) async {
    try {
      final response = await apiCall();
      return SuccessResponse(response);
    } catch (e) {
     final appError = errorParser(e as Exception);
      return ErrorResponse(
        appError: appError,
      );
    }
  }
}
//try catch//
//return safeApiCall(() => api.login());

