import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/auth/register/data/models/register_request.dart';
import 'package:flower_app/features/auth/register/domain/entity/register_entity.dart';

abstract interface class RegisterRepo {
  Future<BaseResponse<RegisterEntity>> register(RegisterRequest request);
}
