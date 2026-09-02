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

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.myCart)),
      body: const CartBody(),
    );
  }
}

class CartBody extends StatelessWidget {
  const CartBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartViewModel, CartState>(
      builder: (context, state) => _body(state),
    );
  }

  Widget _body(CartState state) {
    final request = state.cartState;
    if (request.isLoading && request.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (request.errorMessage.isNotEmpty && request.data == null) {
      return CartErrorState(message: request.errorMessage);
    }
    final cart = request.data ?? const CartEntity.empty();
    if (cart.items.isEmpty) return const CartEmptyState();
    return Column(
      children: [
        Expanded(child: CartItemsList(items: cart.items)),
        CartFooter(cart: cart),
      ],
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key, required this.items});

  final List<CartItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<CartViewModel>().doEvent(LoadCart());
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) => CartLine(item: items[index]),
      ),
    );
  }
}

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<CartViewModel>().doEvent(LoadCart());
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 180.h),
          Icon(AppIcons.shoppingCart, color: context.colors.grey.shade600, size: 60),
          SizedBox(height: 16.h),
          _message(context),
        ],
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

class CartErrorState extends StatelessWidget {
  const CartErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: context.colors.error, size: 60),
            SizedBox(height: 16.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 24.h),
            _retry(context),
          ],
        ),
      ),
    );
  }

  Widget _retry(BuildContext context) {
    return AppButton(
      text: AppString.retry,
      onPressed: () {
        context.read<CartViewModel>().doEvent(LoadCart());
      },
    );
  }
}
