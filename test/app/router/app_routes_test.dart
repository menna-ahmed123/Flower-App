import 'package:flower_app/app/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isMainTab is true only for Home, Category, Cart, and Profile', () {
    expect(AppRoutesName.isMainTab(AppRoutesName.home), isTrue);
    expect(AppRoutesName.isMainTab(AppRoutesName.category), isTrue);
    expect(AppRoutesName.isMainTab(AppRoutesName.cart), isTrue);
    expect(AppRoutesName.isMainTab(AppRoutesName.profile), isTrue);
  });

  test('isMainTab is false for secondary and auth screens', () {
    expect(AppRoutesName.isMainTab('/product-details/abc'), isFalse);
    expect(AppRoutesName.isMainTab(AppRoutesName.bestSeller), isFalse);
    expect(AppRoutesName.isMainTab(AppRoutesName.occasion), isFalse);
    expect(AppRoutesName.isMainTab(AppRoutesName.login), isFalse);
    expect(AppRoutesName.isMainTab(AppRoutesName.register), isFalse);
    expect(AppRoutesName.isMainTab(AppRoutesName.forgetPassword), isFalse);
    expect(AppRoutesName.isMainTab('/forget-password/verification'), isFalse);
  });
}
