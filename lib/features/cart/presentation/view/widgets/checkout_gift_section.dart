import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_textfield.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_state.dart';
import 'package:flower_app/features/cart/presentation/view_model/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutGiftSection extends StatefulWidget {
  const CheckoutGiftSection({super.key});

  @override
  State<CheckoutGiftSection> createState() => _CheckoutGiftSectionState();
}

class _CheckoutGiftSectionState extends State<CheckoutGiftSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CheckoutViewModel>().state;
    _nameController = TextEditingController(text: state.recipientName);
    _phoneController = TextEditingController(text: state.recipientPhone);
    _nameController.addListener(_syncRecipient);
    _phoneController.addListener(_syncRecipient);
  }

  void _syncRecipient() {
    context.read<CheckoutViewModel>().doEvent(
          UpdateGiftRecipient(
            name: _nameController.text,
            phone: _phoneController.text,
          ),
        );
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_syncRecipient)
      ..dispose();
    _phoneController
      ..removeListener(_syncRecipient)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutViewModel, CheckoutState>(
      buildWhen: (previous, current) =>
          previous.isGift != current.isGift ||
          previous.showValidation != current.showValidation,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckoutGiftToggle(enabled: state.isGift),
            if (state.isGift) CheckoutGiftFields(
              nameController: _nameController,
              phoneController: _phoneController,
              showValidation: state.showValidation,
            ),
          ],
        );
      },
    );
  }
}

class CheckoutGiftToggle extends StatelessWidget {
  const CheckoutGiftToggle({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: enabled,
          activeThumbColor: context.colors.white,
          activeTrackColor: context.colors.pink,
          onChanged: (value) {
            context.read<CheckoutViewModel>().doEvent(ToggleCheckoutGift(value));
          },
        ),
        SizedBox(width: 8.w),
        Text(
          AppString.thisIsAGift,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.black,
          ),
        ),
      ],
    );
  }
}

class CheckoutGiftFields extends StatelessWidget {
  const CheckoutGiftFields({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.showValidation,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final bool showValidation;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: showValidation
          ? AutovalidateMode.always
          : AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          SizedBox(height: 12.h),
          LocationTextfield(
            controller: nameController,
            labelText: AppString.name,
            hintText: AppString.enterTheName,
            validator: AppValidators.validateRecipientName,
          ),
          SizedBox(height: 12.h),
          LocationTextfield(
            controller: phoneController,
            labelText: AppString.phoneNumber,
            hintText: AppString.enterPhoneNumber,
            keyboardType: TextInputType.phone,
            validator: AppValidators.phoneValidator,
          ),
        ],
      ),
    );
  }
}
