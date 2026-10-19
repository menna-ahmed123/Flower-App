import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_endpoints.dart';
import 'package:flower_app/core/constants/app_constants.dart';
import 'package:flower_app/features/notification/data/models/update_fcm_token_request.dart';
import 'package:flower_app/features/notification/data/models/update_notification_status_request.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_api_client.g.dart';

@RestApi()
abstract class NotificationApiClient {
  @factoryMethod
  factory NotificationApiClient(Dio dio, {@factoryParam String? baseUrl}) =
      _NotificationApiClient;

  @PUT(ApiEndpoints.fcmToken)
  Future<void> updateFcmToken(@Body() UpdateFcmTokenRequest request);

  @PUT(ApiEndpoints.notificationStatus)
  Future<void> updateNotificationStatus(
    @Path(AppConstants.deviceId) String deviceId,
    @Body() UpdateNotificationStatusRequest request,
  );
}
