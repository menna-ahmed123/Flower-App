import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SyncFcmTokenUseCase {
  SyncFcmTokenUseCase(this._notificationRepo);

  final NotificationRepo _notificationRepo;

  Future<BaseResponse<void>> call({String? token}) {
    return _notificationRepo.syncFcmToken(token: token);
  }
}
