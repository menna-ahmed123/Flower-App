import 'package:flower_app/core/services/fcm_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFcmTokenUseCase {
  final FcmService _fcmService;

  GetFcmTokenUseCase(this._fcmService);

  Future<String?> call() {
    return _fcmService.getToken();
  }
}
