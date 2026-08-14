import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/repos/forget_password_repo.dart';


class ForgetPasswordUseCase {
  final ForgetPasswordRepo forgetPasswordRepo;

  ForgetPasswordUseCase({required this.forgetPasswordRepo});

  Future<BaseResponse<ForgetPasswordEntity>> call({
    required ForgetPasswordEntity forgetPasswordEntity,
  }) {
    return forgetPasswordRepo.forgetPassword(
      forgetPawwsordEntity: forgetPasswordEntity,
    );
  }
}
