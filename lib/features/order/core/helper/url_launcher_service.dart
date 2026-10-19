abstract interface class UrlLauncherService {
  Future<bool> launchPhone(String phoneNumber);

  Future<bool> launchWhatsApp(String phoneNumber);
}
