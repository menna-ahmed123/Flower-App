import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/verify_otp_params.dart';
import 'package:flower_app/features/forget_password/domain/repos/forget_password_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyOtpUseCase {
  final ForgetPasswordRepo forgetPasswordRepo;

  VerifyOtpUseCase({required this.forgetPasswordRepo});

  Future<BaseResponse<VerifyOtpEntity>> call({
    required VerifyOtpParams verifyOtpParams,
  }) {
    return forgetPasswordRepo.verifyOtp(verifyOtpParams: verifyOtpParams);
  }
}
