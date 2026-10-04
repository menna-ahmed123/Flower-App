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
      final added = await cartRemoteDataSource.addCartItem(
        AddCartItemRequest(productId: productId, quantity: quantity),
      );
      _ensureStatus(added.status, added.message, added.code);
      return _mapCart(await cartRemoteDataSource.getCart());
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
  Future<BaseResponse<CartEntity>> removeItem({required String itemId}) {
    return safeCall.safeApiCall(() async {
      return _mapCart(await cartRemoteDataSource.removeCartItem(itemId));
    });
  }

  @override
  Future<BaseResponse<CartEntity>> checkoutDetails({required String cartId}) {
    return safeCall.safeApiCall(() async {
      final response = await cartRemoteDataSource.checkoutDetails(cartId);
      return _mapDetails(response);
    });
  }

  @override
  Future<BaseResponse<DeliveryEstimateEntity>> estimateDelivery({
    required String addressId,
    required String cartId,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await cartRemoteDataSource.estimateDelivery(
        addressId: addressId,
        cartId: cartId,
      );
      return _mapEstimate(response);
    });
  }

  @override
  Future<BaseResponse<OrderEntity>> placeOrder({
    required String idempotencyKey,
    required String cartId,
    required String addressId,
    required bool isGift,
    String? recipientName,
    String? recipientPhone,
    required String paymentMethod,
    String? paymentGateway,
  }) {
    return safeCall.safeApiCall(() async {
      final request = _placeRequest(
        cartId: cartId,
        addressId: addressId,
        isGift: isGift,
        recipientName: recipientName,
        recipientPhone: recipientPhone,
        paymentMethod: paymentMethod,
        paymentGateway: paymentGateway,
      );
      return _mapOrder(
        await cartRemoteDataSource.placeOrder(idempotencyKey, request),
      );
    });
  }

  @override
  Future<BaseResponse<PaymentCheckoutEntity>> createPaymentCheckout({
    required String orderId,
    required double amountTotal,
    required String currency,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await cartRemoteDataSource.createPaymentCheckout(
        PaymentCheckoutRequest(
          orderId: orderId,
          amountTotal: (amountTotal * 100).round(),
          currency: currency,
        ),
      );
      return _mapPayment(response);
    });
  }

  PlaceOrderRequest _placeRequest({
    required String cartId,
    required String addressId,
    required bool isGift,
    String? recipientName,
    String? recipientPhone,
    required String paymentMethod,
    String? paymentGateway,
  }) {
    return PlaceOrderRequest(
      cartId: cartId,
      addressId: addressId,
      isGift: isGift,
      giftRecipient: _giftRecipient(
        isGift: isGift,
        recipientName: recipientName,
        recipientPhone: recipientPhone,
      ),
      paymentMethod: paymentMethod,
      paymentGateway: paymentGateway,
    );
  }

  GiftRecipientRequest? _giftRecipient({
    required bool isGift,
    String? recipientName,
    String? recipientPhone,
  }) {
    if (!isGift) return null;
    return GiftRecipientRequest(
      recipientName: recipientName ?? '',
      recipientPhone: recipientPhone ?? '',
    );
  }

  CartEntity _mapCart(CartResponse response) {
    _ensureStatus(response.status, response.message, response.code);
    return response.data?.toDomain() ?? const CartEntity.empty();
  }

  CartEntity _mapDetails(CheckoutDetailsResponse response) {
    _ensureStatus(response.status, response.message, response.code);
    return response.data?.toDomain() ?? const CartEntity.empty();
  }

  DeliveryEstimateEntity _mapEstimate(EstimateDeliveryResponse response) {
    _ensureStatus(response.status, response.message, response.code);
    return response.toDomain();
  }

  OrderEntity _mapOrder(OrderResponse response) {
    _ensureStatus(response.status, response.message, response.code);
    return response.data?.toDomain() ?? const OrderEntity();
  }

  PaymentCheckoutEntity _mapPayment(PaymentCheckoutResponse response) {
    if (response.isSuccess == true && response.isFailure != true) {
      return _paymentValue(response.value);
    }
    throw ApiException(message: _paymentMessage(response.error?.message));
  }

  PaymentCheckoutEntity _paymentValue(PaymentCheckoutValue? value) {
    return PaymentCheckoutEntity(
      checkoutUrl: value?.checkoutUrl ?? '',
      stripeSessionId: value?.stripeSessionId ?? '',
      paymentAttemptId: value?.paymentAttemptId ?? '',
    );
  }

  String _paymentMessage(String? message) {
    if (message != null && message.isNotEmpty) return message;
    return 'Payment checkout failed';
  }

  void _ensureStatus(Object? status, String? message, int? code) {
    if (status != false) return;
    throw ApiException(
      message: (message ?? '').isNotEmpty
          ? message!
          : statusCodeToMessage(code),
      statusCode: code,
    );
  }
}
