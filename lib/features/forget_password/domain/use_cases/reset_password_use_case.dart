import 'package:injectable/injectable.dart';

import '../../../../core/base/base_response.dart';
import '../entities/reset_password_entity.dart';
import '../entities/reset_password_params.dart';
import '../repos/forget_password_repo.dart';

@injectable
class ResetPasswordUseCase {
  final ForgetPasswordRepo forgetPasswordRepo;

  ResetPasswordUseCase({required this.forgetPasswordRepo});

  Future<BaseResponse<ResetPasswordEntity>> call({
    required ResetPasswordParams resetPasswordParams,
  }) {
    return forgetPasswordRepo.resetPassword(
      resetPasswordParams: resetPasswordParams,
    );
  }
}
