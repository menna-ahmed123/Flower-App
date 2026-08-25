import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  ApiEndpoints._();

 static final  baseUrl= dotenv.get('BASE_URL');
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
