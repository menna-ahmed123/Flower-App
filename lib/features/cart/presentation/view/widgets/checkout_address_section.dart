import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_icons.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_event.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_view_model.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.deliveryAddress,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        const CheckoutAddressList(),
        SizedBox(height: 12.h),
        const CheckoutAddAddressButton(),
      ],
    );
  }
}

class CheckoutAddressList extends StatelessWidget {
  const CheckoutAddressList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DefaultAddressViewModel, DefaultAddressState>(
      builder: (context, addressState) {
        if (addressState.defaultAddressesState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final addresses = addressState.defaultAddressesState.data ?? [];
        return BlocBuilder<CheckoutViewModel, CheckoutState>(
          buildWhen: (previous, current) =>
              previous.selectedAddress != current.selectedAddress,
          builder: (context, checkout) {
            return Column(
              children: [
                for (final address in addresses) ...[
                  CheckoutAddressTile(
                    address: address,
                    selected: address.id == checkout.selectedAddress?.id,
                  ),
                  SizedBox(height: 10.h),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

class CheckoutAddressTile extends StatelessWidget {
  const CheckoutAddressTile({
    super.key,
    required this.address,
    required this.selected,
  });

  final AddressEntity address;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: () {
        context.read<CheckoutViewModel>().doEvent(
              SelectCheckoutAddress(address),
            );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? colors.pink : colors.grey.shade300,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? colors.pink : colors.grey.shade800,
            ),
            SizedBox(width: 12.w),
            Expanded(child: CheckoutAddressLabels(address: address)),
            IconButton(
              onPressed: () => _edit(context),
              icon: Icon(AppIcons.edit, color: colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final added = await context.push(AppRoutesName.address, extra: address);
    if (!context.mounted || added != true) return;
    context.read<DefaultAddressViewModel>().doEvent(LoadSavedAddresses());
  }
}

class CheckoutAddressLabels extends StatelessWidget {
  const CheckoutAddressLabels({super.key, required this.address});

  final AddressEntity address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.label ??
              address.recipientName ??
              address.city ??
              AppString.address,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          [
            address.address,
            address.area,
          ].where((value) => (value ?? '').trim().isNotEmpty).join(' - '),
          style: TextStyle(fontSize: 13.sp, color: context.colors.grey.shade800),
        ),
      ],
    );
  }
}

class CheckoutAddAddressButton extends StatelessWidget {
  const CheckoutAddAddressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _add(context),
        icon: Icon(AppIcons.plus, color: context.colors.pink),
        label: Text(
          AppString.addNew,
          style: TextStyle(
            color: context.colors.pink,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.colors.pink),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final added = await context.push(AppRoutesName.address);
    if (!context.mounted || added != true) return;
    context.read<DefaultAddressViewModel>().doEvent(LoadSavedAddresses());
  }
}
