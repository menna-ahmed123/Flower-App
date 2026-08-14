import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/forget_password/domain/entities/forget_password_entity.dart';

abstract class ForgetPasswordRepo {

  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword({
    required ForgetPasswordEntity forgetPawwsordEntity
  });

}