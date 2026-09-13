import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

abstract interface class CartRepo {
  Future<BaseResponse<CartEntity>> getCart();

  Future<BaseResponse<CartEntity>> addItem({
    required String productId,
    int quantity = 1,
  });

  Future<BaseResponse<CartEntity>> updateItem({
    required String itemId,
    required int quantity,
  });

  Future<BaseResponse<bool>> removeItem({required String itemId});
}
