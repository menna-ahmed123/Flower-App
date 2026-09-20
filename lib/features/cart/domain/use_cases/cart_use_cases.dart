import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCartUseCase {
  GetCartUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<CartEntity>> getCart() {
    return cartRepo.getCart();
  }
}

@injectable
class AddCartItemUseCase {
  AddCartItemUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<CartEntity>> addItem({
    required String productId,
    int quantity = 1,
  }) {
    return cartRepo.addItem(productId: productId, quantity: quantity);
  }
}

@injectable
class UpdateCartItemUseCase {
  UpdateCartItemUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<CartEntity>> updateItem({
    required String itemId,
    required int quantity,
  }) {
    return cartRepo.updateItem(itemId: itemId, quantity: quantity);
  }
}

@injectable
class RemoveCartItemUseCase {
  RemoveCartItemUseCase(this.cartRepo);

  final CartRepo cartRepo;

  Future<BaseResponse<bool>> removeItem({required String itemId}) {
    return cartRepo.removeItem(itemId: itemId);
  }
}
