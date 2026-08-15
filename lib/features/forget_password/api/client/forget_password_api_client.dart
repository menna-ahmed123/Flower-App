import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'forget_password_api_client.g.dart';

@RestApi()
abstract class ForgetPasswordApiClient {
  factory ForgetPasswordApiClient(Dio dio, {String? baseUrl}) =
      _ForgetPasswordApiClient;

  @POST(ApiEndpoints.forgotPassword)
  Future<ForgetPasswordResponseModel> forgotPassword(
    @Body() ForgetPasswordRequestModel request,
  );

  @POST(ApiEndpoints.verifyOtp)
  Future<VerifyOtpResponseModel> verifyOtp(
    @Body() VerifyOtpRequestModel request,
  );
}
