import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/cart_footer.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/cart_line.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    _loadIfNeeded();
  }

  void _loadIfNeeded() {
    final request = context.read<CartViewModel>().state.cartState;
    if (!_needsCartLoad(request)) return;
    context.read<CartViewModel>().doEvent(const LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartViewModel, CartState>(
      listenWhen: (previous, current) {
        return !_needsCartLoad(previous.cartState) &&
            _needsCartLoad(current.cartState);
      },
      listener: (context, _) => _loadIfNeeded(),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Text(AppString.myCart),
          ),
        ),
        body: const CartBody(),
      ),
    );
  }
}

bool _needsCartLoad(BaseState<CartEntity> request) {
  if (request.isLoading || request.errorMessage.isNotEmpty) return false;
  if (request.data == null) return true;
  return request.data!.items.isEmpty && request.data!.itemCount > 0;
}

class CartBody extends StatelessWidget {
  const CartBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartViewModel, CartState>(
      builder: (context, state) => _body(context, state),
    );
  }

  Widget _body(BuildContext context, CartState state) {
    final request = state.cartState;
    if (request.data == null && request.errorMessage.isEmpty) {
      return const CartLoading();
    }
    if (request.errorMessage.isNotEmpty && request.data == null) {
      return CartErrorState(message: request.errorMessage);
    }
    return _loadedBody(context, request);
  }

  Widget _loadedBody(BuildContext context, BaseState<CartEntity> request) {
    final cart = request.data ?? const CartEntity.empty();
    if (cart.items.isEmpty &&
        cart.itemCount > 0 &&
        request.errorMessage.isEmpty) {
      return const CartLoading();
    }
    if (cart.items.isEmpty) return const CartEmptyState();
    return Column(
      children: [
        if (cart.hasChanges || cart.pricingUnavailable)
          CartStatusBanner(cart: cart),
        Expanded(child: CartItemsList(items: cart.items)),
        CartFooter(
          cart: cart,
          onCheckout: () => context.push(AppRoutesName.checkout),
        ),
      ],
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key, required this.items});

  final List<CartItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final horizontal = MediaQuery.sizeOf(context).width >= 600 ? 48.w : 16.w;
    return RefreshIndicator(
      onRefresh: () {
        return context.read<CartViewModel>().doEvent(const LoadCart());
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(horizontal, 8.h, horizontal, 8.h),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (context, index) => CartLine(item: items[index]),
      ),
    );
  }
}

class CartLoading extends StatelessWidget {
  const CartLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<CartViewModel>().doEvent(const LoadCart()),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        children: [
          SizedBox(height: 160.h),
          _icon(context),
          SizedBox(height: 16.h),
          _message(context),
        ],
      ),
    );
  }

  Widget _icon(BuildContext context) {
    return Center(
      child: Icon(
        AppIcons.shoppingCart,
        color: context.colors.grey.shade600,
        size: 64,
      ),
    );
  }

  Widget _message(BuildContext context) {
    return Text(
      AppString.cartIsEmpty,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.sp,
        color: context.colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class CartStatusBanner extends StatelessWidget {
  const CartStatusBanner({super.key, required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: cart.pricingUnavailable
          ? colors.grey.shade100
          : colors.pink.shade50,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        child: Text(_message, style: _style(context)),
      ),
    );
  }

  String get _message {
    if (cart.pricingUnavailable) return AppString.cartPricingUnavailable;
    return AppString.cartPricesUpdated;
  }

  TextStyle _style(BuildContext context) {
    return TextStyle(
      fontSize: 13.sp,
      height: 1.35,
      fontWeight: FontWeight.w500,
      color: context.colors.grey.shade800,
    );
  }
}

class CartErrorState extends StatelessWidget {
  const CartErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: context.colors.error, size: 64),
            SizedBox(height: 16.h),
            _text(context),
            SizedBox(height: 24.h),
            _retry(context),
          ],
        ),
      ),
    );
  }

  Widget _text(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: context.colors.grey.shade800,
      ),
    );
  }

  Widget _retry(BuildContext context) {
    return AppButton(
      text: AppString.retry,
      onPressed: () {
        context.read<CartViewModel>().doEvent(const LoadCart());
      },
    );
  }
}
