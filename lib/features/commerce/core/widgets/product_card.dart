import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/quantity_stepper.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.onAddToCart,
    this.oldPrice,
    this.discount,
    required this.onTap,
    this.isLoading = false,
  });

  final String productId;
  final String imageUrl;
  final String name;
  final String price;
  final String? oldPrice;
  final String? discount;
  final VoidCallback onTap;
  final Future<void> Function() onAddToCart;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 163.w,
        //  height: 229.h,
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.grey.shade600, width: 1.w),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 147.w,
                    height: 131.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        color: colors.grey.shade300,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.pink,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        color: colors.grey.shade300,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: colors.grey.shade700,
                          size: 28.w,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (oldPrice != null) ...[
                    SizedBox(width: 8.w),
                    Text(
                      oldPrice!,
                      style: TextStyle(
                        color: colors.grey.shade700,
                        fontSize: 13.sp,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                  if (discount != null) ...[
                    const Spacer(),
                    Text(
                      discount!,
                      style: TextStyle(
                        color: colors.green,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: _cartControl(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cartControl(BuildContext context) {
    return BlocSelector<CartViewModel, CartState, CartItemEntity?>(
      selector: (state) => _cartItemForProduct(state, productId),
      builder: (context, cartItem) {
        if (cartItem == null) {
          return _addToCartButton(context);
        }
        return _quantityControls(context, cartItem);
      },
    );
  }

  Widget _addToCartButton(BuildContext context) {
    final colors = context.colors;
    return ElevatedButton(
      onPressed: isLoading ? null : onAddToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.pink,
        foregroundColor: colors.white,
        disabledBackgroundColor: colors.disabledButton,
        disabledForegroundColor: colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 7.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 18.w,
              height: 18.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AppIcons.shoppingCart, size: 18.w),
                SizedBox(width: 6.w),
                Text(
                  AppString.addToCart,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _quantityControls(BuildContext context, CartItemEntity cartItem) {
    final canIncrement =
        cartItem.stock == null || cartItem.quantity < cartItem.stock!;
    return Center(
      child: QuantityStepper(
        quantity: cartItem.quantity,
        canIncrement: canIncrement,
        onDecrement: () {
          context.read<CartViewModel>().doEvent(
            ChangeCartItemQuantity(itemId: cartItem.id, delta: -1),
          );
        },
        onIncrement: () {
          context.read<CartViewModel>().doEvent(
            ChangeCartItemQuantity(itemId: cartItem.id, delta: 1),
          );
        },
      ),
    );
  }
}

CartItemEntity? _cartItemForProduct(CartState state, String productId) {
  final items = state.cartState.data?.items;
  if (items == null) return null;
  for (final item in items) {
    if (item.productId == productId) return item;
  }
  return null;
}
