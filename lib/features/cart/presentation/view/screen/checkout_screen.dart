import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_event.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_view_model.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_state.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/checkout_address_section.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/checkout_gift_section.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/checkout_payment_section.dart';
import 'package:flower_app/features/cart/presentation/view/widgets/checkout_summary_section.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CheckoutViewModel>().doEvent(LoadCheckoutPreview());
    context.read<DefaultAddressViewModel>().doEvent(LoadSavedAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.checkout,
        onBack: () {
          if (context.canPop()) context.pop();
        },
      ),
      body: const CheckoutBody(),
    );
  }
}

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({super.key});

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  int _addressCount = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DefaultAddressViewModel, DefaultAddressState>(
          listener: _onAddresses,
        ),
        BlocListener<CheckoutViewModel, CheckoutState>(
          listenWhen: (previous, current) =>
              previous.destination != current.destination ||
              previous.submitState.errorMessage !=
                  current.submitState.errorMessage,
          listener: _onCheckout,
        ),
      ],
      child: const Column(
        children: [
          Expanded(child: CheckoutForm()),
          CheckoutSubmitBar(),
        ],
      ),
    );
  }

  void _onAddresses(BuildContext context, DefaultAddressState state) {
    final addresses = state.defaultAddressesState.data ?? [];
    final checkout = context.read<CheckoutViewModel>();
    if (addresses.length > _addressCount && _addressCount > 0) {
      checkout.doEvent(SelectCheckoutAddress(addresses.last));
    } else if (!checkout.state.hasAddress && addresses.isNotEmpty) {
      checkout.doEvent(SelectCheckoutAddress(_preferred(addresses)));
    }
    _addressCount = addresses.length;
  }

  void _onCheckout(BuildContext context, CheckoutState state) {
    final error = state.submitState.errorMessage;
    if (error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    final destination = state.destination;
    if (destination == null) return;
    context.read<CheckoutViewModel>().doEvent(ClearCheckoutNavigation());
    if (destination == CheckoutDestination.confirmation) {
      context.read<CartViewModel>().doEvent(ResetCart());
    }
    context.push(
      destination == CheckoutDestination.payment
          ? AppRoutesName.payment
          : AppRoutesName.confirmation,
      extra: context.read<CheckoutViewModel>(),
    );
  }
}

class CheckoutForm extends StatelessWidget {
  const CheckoutForm({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= 600 ? 48.w : 16.w;
    return ListView(
      padding: EdgeInsets.fromLTRB(horizontal, 12.h, horizontal, 24.h),
      children: [
        const CheckoutAddressSection(),
        _sectionGap(context),
        const CheckoutPaymentSection(),
        _sectionGap(context),
        const CheckoutGiftSection(),
        _sectionGap(context),
        const CheckoutSummarySection(),
      ],
    );
  }

  Widget _sectionGap(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(
        height: 24.h,
        color: context.colors.grey.shade600.withValues(alpha: 0.35),
      ),
    );
  }
}

class CheckoutSubmitBar extends StatelessWidget {
  const CheckoutSubmitBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final horizontal = MediaQuery.sizeOf(context).width >= 600 ? 48.w : 16.w;
    return Material(
      color: colors.white,
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.white,
          border: Border(
            top: BorderSide(
              color: colors.grey.shade600.withValues(alpha: 0.35),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.black.withValues(alpha: 0.06),
              blurRadius: 8.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 14.h, horizontal, 12.h),
            child: BlocBuilder<CheckoutViewModel, CheckoutState>(
              builder: (context, state) {
                return AppButton(
                  text: AppString.placeOrder,
                  isLoading: state.submitState.isLoading,
                  onPressed: state.canSubmit
                      ? () {
                          context.read<CheckoutViewModel>().doEvent(
                                SubmitPlaceOrder(),
                              );
                        }
                      : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

AddressEntity _preferred(List<AddressEntity> addresses) {
  return addresses.firstWhere(
    (address) => address.isDefault,
    orElse: () => addresses.first,
  );
}
