class ApiEndpoints {
  ApiEndpoints._();


    static const String baseUrl = 'http://192.168.1.237:8080/api/v1';

  //// AUTH ////
  static const String forgotPassword = '/identity/auth/forgot-password';
  static const String verifyOtp = '/identity/auth/verify-otp';
  static const String resetPassword = '/identity/auth/reset-password';
  static const String login = '/identity/auth/login';
  static const String register = '/identity/users/register';

  //// Commerce ////
 static const String home = '/catalog/home/layout';
 static const String allCategories = '/catalog/categories';
 static const String allOccasions = '/catalog/occasions';
 static const String allProducts = '/catalog/products';
 static const String productDetails = '/catalog/products/{id}';
}
