import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/quantity_stepper.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartLine extends StatelessWidget {
  const CartLine({super.key, required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmRemoval(context),
      onDismissed: (_) {
        context.read<CartViewModel>().doEvent(
          RemoveCartItemEvent(itemId: item.id),
        );
      },
      background: _dismissBackground(context),
      child: _content(context),
    );
  }

  Widget _dismissBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      color: context.colors.error,
      child: Icon(AppIcons.trash, color: context.colors.white),
    );
  }

  Widget _content(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          _image(context),
          SizedBox(width: 12.w),
          Expanded(child: _info(context)),
          _stepper(context),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: CachedNetworkImage(
        imageUrl: item.imageUrl,
        width: 72.w,
        height: 72.w,
        fit: BoxFit.cover,
        errorWidget: (_, _, _) {
          return Icon(Icons.image_not_supported_outlined, size: 28.w);
        },
      ),
    );
  }

  Widget _info(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _name(context),
        if (item.attributes != null && item.attributes!.isNotEmpty)
          _attributes(context),
        SizedBox(height: 8.h),
        _price(context),
      ],
    );
  }

  Widget _name(BuildContext context) {
    return Text(
      item.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: context.colors.black,
      ),
    );
  }

  Widget _price(BuildContext context) {
    return Text(
      '${AppString.egp} ${item.price.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: context.colors.black,
      ),
    );
  }

  Widget _attributes(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Text(
        item.attributes!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.sp, color: context.colors.grey.shade700),
      ),
    );
  }

  Widget _stepper(BuildContext context) {
    final canIncrement = item.stock == null || item.quantity < item.stock!;
    return QuantityStepper(
      quantity: item.quantity,
      canIncrement: canIncrement,
      onDecrement: () {
        context.read<CartViewModel>().doEvent(
          ChangeCartItemQuantity(itemId: item.id, delta: -1),
        );
      },
      onIncrement: () {
        context.read<CartViewModel>().doEvent(
          ChangeCartItemQuantity(itemId: item.id, delta: 1),
        );
      },
    );
  }
}

Future<bool> _confirmRemoval(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => _RemoveCartItemDialog(dialogContext: dialogContext),
  );
  return result ?? false;
}

class _RemoveCartItemDialog extends StatelessWidget {
  const _RemoveCartItemDialog({required this.dialogContext});

  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppString.removeItem),
      content: const Text(AppString.removeItemConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text(AppString.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text(AppString.remove),
        ),
      ],
    );
  }
}
