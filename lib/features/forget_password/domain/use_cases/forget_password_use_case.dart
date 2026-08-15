import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_params.dart';
import 'package:flower_app/features/forget_password/domain/repos/forget_password_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUseCase {
  final ForgetPasswordRepo forgetPasswordRepo;

  ForgetPasswordUseCase({required this.forgetPasswordRepo});

  Future<BaseResponse<ForgetPasswordEntity>> call({
    required ForgetPasswordParams forgetPasswordParams,
  }) {
    return forgetPasswordRepo.forgetPassword(
      forgetPasswordParams: forgetPasswordParams,
    );
  }
}
