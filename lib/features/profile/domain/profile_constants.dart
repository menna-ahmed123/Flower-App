class ProfileConstants {
  ProfileConstants._();

  // TODO: confirm with backend: supported profile image formats and size limit.
  static const int maxImageBytes = 5 * 1024 * 1024;
  static const allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};
}