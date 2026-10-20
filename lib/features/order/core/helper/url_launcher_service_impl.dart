import 'package:flower_app/features/order/core/helper/url_launcher_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherServiceImpl implements UrlLauncherService {
  const UrlLauncherServiceImpl();

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

  static Uri _whatsappUri(String phoneNumber) =>
      Uri.parse('https://wa.me/${_digits(phoneNumber)}');

  static String _digits(String phoneNumber) =>
      phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
}
