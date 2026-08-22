class ImageUrlHelper {
  static const String baseUrl = 'http://192.168.1.237:8080';

  static String getFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http://') ||
        imageUrl.startsWith('https://')) {
      return imageUrl;
    }

    return '$baseUrl$imageUrl';
  }
}