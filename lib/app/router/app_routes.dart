abstract final class AppRoutesName {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String verification = 'verification';
  static const String resetPassword = 'reset-password';
  static const String home = '/home';
  static const String bestSeller = '/best_seller';
  static const productDetails = '/product-details/:productId';
  static const String occasion = '/occasion';
  static const String category = '/category';
  static const String cart = '/cart';
  static const String profile = '/profile';

  static const Set<String> mainTabPaths = {
    home,
    category,
    cart,
    profile,
  };

  static bool isMainTab(String path) => mainTabPaths.contains(path);
}
