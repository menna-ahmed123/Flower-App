import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/error_parser.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:flower_app/features/cart/data/models/cart_models.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo/cart_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRepo)
class CartRepoImpl implements CartRepo {
  CartRepoImpl(this.cartRemoteDataSource, this.safeCall);

  final CartRemoteDataSource cartRemoteDataSource;
  final SafeCall safeCall;

  @override
  Future<BaseResponse<CartEntity>> getCart() {
    return safeCall.safeApiCall(() async {
      return _mapCart(await cartRemoteDataSource.getCart());
    });
  }

  @override
  Future<BaseResponse<CartEntity>> addItem({
    required String productId,
    int quantity = 1,
  }) {
    return safeCall.safeApiCall(() async {
      final request = AddCartItemRequest(
        productId: productId,
        quantity: quantity,
      );
      return _mapCart(await cartRemoteDataSource.addCartItem(request));
    });
  }

  @override
  Future<BaseResponse<CartEntity>> updateItem({
    required String itemId,
    required int quantity,
  }) {
    return safeCall.safeApiCall(() async {
      final request = UpdateCartItemRequest(quantity: quantity);
      return _mapCart(
        await cartRemoteDataSource.updateCartItem(itemId, request),
      );
    });
  }

  @override
  Future<BaseResponse<bool>> removeItem({required String itemId}) {
    return safeCall.safeApiCall(() async {
      await cartRemoteDataSource.removeCartItem(itemId);
      return true;
    });
  }

  CartEntity _mapCart(CartResponse response) {
    if (response.success == false) {
      throw ApiException(
        message: (response.message ?? '').isNotEmpty
            ? response.message!
            : statusCodeToMessage(response.statusCode),
        statusCode: response.statusCode,
      );
    }
    return response.data?.toDomain() ?? const CartEntity.empty();
  }
}
