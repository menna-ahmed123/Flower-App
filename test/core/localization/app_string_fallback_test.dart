import 'package:flower_app/core/constants/app_string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses english copy before translations are loaded', () {
    expect(AppString.login, 'Login');
    expect(AppString.cartIsEmpty, 'Your cart is empty');
    expect(AppString.itemsCount(3), '3 items');
    expect(
      AppString.quantityRequestedAvailable('Carnations', 3, 0),
      'Carnations: 3 requested, 0 available',
    );
  });
}
