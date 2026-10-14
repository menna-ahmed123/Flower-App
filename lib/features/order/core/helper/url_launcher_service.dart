import 'package:url_launcher/url_launcher.dart';

abstract class UrlLauncherService {
  Future<bool> launchPhone(String phoneNumber);
  Future<bool> launchWhatsApp(String phoneNumber);
  static String cleanPhoneNumber(String raw) =>
      raw.replaceAll(RegExp(r'[^\d]'), '');
  static Uri phoneUri(String phoneNumber) =>
      Uri(scheme: 'tel', path: phoneNumber);
  static Uri whatsappUri(String phoneNumber) =>
      Uri.parse('https://wa.me/${cleanPhoneNumber(phoneNumber)}');
}
class PluginUrlLauncherService implements UrlLauncherService {
  const PluginUrlLauncherService();

  @override
  Future<bool> launchPhone(String phoneNumber) async {
    final uri = UrlLauncherService.phoneUri(phoneNumber);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri);
  }

  @override
  Future<bool> launchWhatsApp(String phoneNumber) async {
    final uri = UrlLauncherService.whatsappUri(phoneNumber);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
