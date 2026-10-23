import 'package:flower_app/features/order/core/helper/url_launcher_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherServiceImpl implements UrlLauncherService {
  const UrlLauncherServiceImpl();

  // wa.me only accepts international numbers; backend numbers arrive in
  // local form (leading 0), so the country code is prepended.
  static const String _countryCode = '20';

  @override
  Future<bool> launchPhone(String phoneNumber) async {
    final uri = _phoneUri(phoneNumber);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri);
  }

  @override
  Future<bool> launchWhatsApp(String phoneNumber) async {
    final uri = _whatsappUri(phoneNumber);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Uri _phoneUri(String phoneNumber) =>
      Uri(scheme: 'tel', path: phoneNumber);

  static Uri _whatsappUri(String phoneNumber) {
    final digits = _digits(phoneNumber);
    final international = digits.startsWith('0')
        ? '$_countryCode${digits.substring(1)}'
        : digits;
    return Uri.parse('https://wa.me/$international');
  }

  static String _digits(String phoneNumber) =>
      phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
}
