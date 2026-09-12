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
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      children: [
        const CheckoutAddressSection(),
        SizedBox(height: 20.h),
        const CheckoutPaymentSection(),
        SizedBox(height: 20.h),
        const CheckoutGiftSection(),
        SizedBox(height: 20.h),
        const CheckoutSummarySection(),
      ],
    );
  }
}

class CheckoutSubmitBar extends StatelessWidget {
  const CheckoutSubmitBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
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
    );
  }
}

AddressEntity _preferred(List<AddressEntity> addresses) {
  return addresses.firstWhere(
    (address) => address.isDefault,
    orElse: () => addresses.first,
  );
}
