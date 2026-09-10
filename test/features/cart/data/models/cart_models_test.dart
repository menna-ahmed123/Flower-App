import 'package:flower_app/core/constants/api_query_params.dart';
import 'package:flower_app/features/cart/data/models/cart_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses Team 1 cart lines into items', () {
    final cart = CartResponse.fromJson({
      'success': true,
      'statusCode': 200,
      'data': {
        'id': 'cart-1',
        'lines': [
          {
            'id': 'item-1',
            'productId': 'product-1',
            'productName': 'Red Rose',
            'unitPrice': 100,
            'quantity': 2,
          },
        ],
        'itemCount': 2,
        'subtotal': 200,
      },
    });

    final entity = cart.data!.toDomain();
    expect(entity.items, hasLength(1));
    expect(entity.items.first.id, 'item-1');
    expect(entity.items.first.productId, 'product-1');
    expect(entity.items.first.name, 'Red Rose');
    expect(entity.items.first.price, 100);
    expect(entity.itemCount, 2);
  });

  test('add and update bodies include storeId', () {
    expect(
      const AddCartItemRequest(productId: 'p1', quantity: 2).toJson(),
      {
        'productId': 'p1',
        'quantity': 2,
        'storeId': ApiQueryParams.defaultStoreId,
      },
    );
    expect(const UpdateCartItemRequest(quantity: 4).toJson(), {
      'quantity': 4,
      'storeId': ApiQueryParams.defaultStoreId,
    });
  });
}
