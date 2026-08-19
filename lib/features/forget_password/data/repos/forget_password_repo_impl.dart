import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/forget_password/data/data_sources/remote/forget_password_remote_data_source.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/forget_password_response_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_request_model.dart';
import 'package:flower_app/features/forget_password/data/models/verify_otp_response_model.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flower_app/features/forget_password/domain/repos/forget_password_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgetPasswordRepo)
class ForgetPasswordRepoImpl implements ForgetPasswordRepo {
  final ForgetPasswordRemoteDataSource remoteDataSource;

  ForgetPasswordRepoImpl({required this.remoteDataSource});

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordParams forgetPasswordParams,
  }) async {
    final requestModel = ForgetPasswordRequestModel.fromDomain(
      forgetPasswordParams,
    );

    final response = await remoteDataSource.forgetPassword(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessResponse<ForgetPasswordResponseModel>():
        final entity = response.data.toDomain();
        return SuccessResponse<ForgetPasswordEntity>(entity);
      case ErrorResponse<ForgetPasswordResponseModel>():
        return ErrorResponse<ForgetPasswordEntity>(appError: response.appError);    
    }
  }

  @override
  Future<BaseResponse<VerifyOtpEntity>> verifyOtp({
    required VerifyOtpParams verifyOtpParams,
  }) async {
    final requestModel = VerifyOtpRequestModel.fromDomain(verifyOtpParams);

    final response = await remoteDataSource.verifyOtp(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessResponse<VerifyOtpResponseModel>():
        final entity = response.data.toDomain();

        return SuccessResponse<VerifyOtpEntity>(entity);

      case ErrorResponse<VerifyOtpResponseModel>():
        return ErrorResponse<VerifyOtpEntity>(appError: response.appError);
    }
  }
}
