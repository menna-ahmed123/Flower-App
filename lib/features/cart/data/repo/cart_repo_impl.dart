import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/errors/api_exception.dart';
import 'package:flower_app/core/errors/error_parser.dart';
import 'package:flower_app/core/network/safe_call.dart';
import 'package:flower_app/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:flower_app/features/cart/data/models/cart_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_preview_response.dart';
import 'package:flower_app/features/cart/data/models/checkout_request.dart';
import 'package:flower_app/features/cart/data/models/order_response.dart';
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

  @override
  Future<BaseResponse<CartEntity>> previewCheckout({
    String? addressId,
    CheckoutGiftEntity? gift,
  }) {
    return safeCall.safeApiCall(() async {
      final request = _checkoutRequest(addressId: addressId, gift: gift);
      return _mapPreview(await cartRemoteDataSource.previewCheckout(request));
    });
  }

  @override
  Future<BaseResponse<OrderEntity>> placeOrder({
    required String idempotencyKey,
    required int paymentMethod,
    required double expectedTotal,
    String? addressId,
    CheckoutGiftEntity? gift,
  }) {
    return safeCall.safeApiCall(() async {
      final request = _checkoutRequest(
        addressId: addressId,
        gift: gift,
        paymentMethod: paymentMethod,
        expectedTotal: expectedTotal,
      );
      return _mapOrder(
        await cartRemoteDataSource.placeOrder(idempotencyKey, request),
      );
    });
  }

  @override
  Future<BaseResponse<bool>> processPayment() {
    return safeCall.safeApiCall(() async {
      await cartRemoteDataSource.processPayment();
      return true;
    });
  }

  CheckoutRequest _checkoutRequest({
    String? addressId,
    CheckoutGiftEntity? gift,
    int? paymentMethod,
    double? expectedTotal,
  }) {
    return CheckoutRequest(
      addressId: gift == null ? addressId : null,
      gift: gift == null ? null : CheckoutGiftRequest.fromEntity(gift),
      paymentMethod: paymentMethod,
      expectedTotal: expectedTotal,
    );
  }

  CartEntity _mapCart(CartResponse response) {
    _ensureSuccess(response.success, response.message, response.statusCode);
    return response.data?.toDomain() ?? const CartEntity.empty();
  }

  CartEntity _mapPreview(CheckoutPreviewResponse response) {
    _ensureSuccess(response.success, response.message, response.statusCode);
    return response.data?.toDomain() ?? const CartEntity.empty();
  }

  OrderEntity _mapOrder(OrderResponse response) {
    _ensureSuccess(response.success, response.message, response.statusCode);
    return response.data?.toDomain() ?? const OrderEntity();
  }

  void _ensureSuccess(bool? success, String? message, int? statusCode) {
    if (success != false) return;
    throw ApiException(
      message: (message ?? '').isNotEmpty
          ? message!
          : statusCodeToMessage(statusCode),
      statusCode: statusCode,
    );
  }
}
