import 'package:injectable/injectable.dart';

// TODO: temporary in-memory value, replace with persistent storage after review
@lazySingleton
class NotificationStatusHolder {
  bool isNotificationsEnabled = true;
}
