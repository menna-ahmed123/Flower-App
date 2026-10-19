import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/constants/app_string.dart';

extension TrackingDateFormatter on DateTime {
  String get trackingEtaLabel =>
      DateFormat('d MMMM yyyy, h:mm a').format(toLocal());

  String get trackingTimelineLabel =>
      DateFormat('dd MMM yyyy - h:mm a').format(toLocal());
}

extension TrackingAgeLabel on Duration {
  String get trackingAgoLabel {
    if (inSeconds < 60) {
      return trackingPhrase(AppString.trackingSecondsAgo, '$inSeconds');
    }
    if (inMinutes < 60) {
      return trackingPhrase(AppString.trackingMinutesAgo, '$inMinutes');
    }
    return trackingPhrase(AppString.trackingHoursAgo, '$inHours');
  }
}

String trackingPhrase(String template, String value) =>
    template.replaceAll('{value}', value);
