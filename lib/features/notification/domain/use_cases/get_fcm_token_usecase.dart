import 'package:flower_app/features/notification/domain/repo/notification_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFcmTokenUseCase {
  GetFcmTokenUseCase(this._notificationRepo);

  final NotificationRepo _notificationRepo;

  Future<String?> call() {
    return _notificationRepo.getFcmToken();
  }
}
