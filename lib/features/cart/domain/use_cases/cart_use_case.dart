import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class CartUseCase {
  CartUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<CartEntity>> getCart() {
    return cartRepo.getCart();
  }

  Future<BaseResponse<CartEntity>> addItem({
    required String productId,
    int quantity = 1,
  }) {
    return cartRepo.addItem(productId: productId, quantity: quantity);
  }

  Future<BaseResponse<CartEntity>> updateItem({
    required String itemId,
    required int quantity,
  }) {
    return cartRepo.updateItem(itemId: itemId, quantity: quantity);
  }

  Future<BaseResponse<bool>> removeItem({required String itemId}) {
    return cartRepo.removeItem(itemId: itemId);
  }
}
