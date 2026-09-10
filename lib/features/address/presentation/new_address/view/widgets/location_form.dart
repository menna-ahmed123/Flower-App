import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_textfield.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationForm extends StatefulWidget {
  final ValueChanged<AddressEntity>? onSave;
  final AddressEntity? address;

  const LocationForm({
    super.key,
    this.onSave,
    this.address,
  });

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _cityController =
      TextEditingController();

  final TextEditingController _areaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _fillForm(widget.address);
    _addressController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _nameController.addListener(_onFormChanged);
    _cityController.addListener(_onFormChanged);
    _areaController.addListener(_onFormChanged);
  }

  @override
  void didUpdateWidget(covariant LocationForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.address != widget.address) {
      _fillForm(widget.address);
    }
  }

  void _fillForm(AddressEntity? address) {
    if (address == null) {
      return;
    }

    _addressController.text = address.address ?? '';
    _phoneController.text = address.phoneNumber ?? '';
    _nameController.text = address.recipientName ?? '';
    _cityController.text = address.city ?? '';
    _areaController.text = address.area ?? '';
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }
  bool get _hasFormChanges {
    final original = widget.address;

    if (original == null) {
      return true;
    }
    return _addressController.text != (original.address ?? '') ||
        _phoneController.text != (original.phoneNumber ?? '') ||
        _nameController.text != (original.recipientName ?? '') ||
        _cityController.text != (original.city ?? '') ||
        _areaController.text != (original.area ?? '');
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final address = AddressEntity(
      id: widget.address?.id,
      label: widget.address?.label,
      address: _addressController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      recipientName: _nameController.text.trim(),
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
    );

    widget.onSave?.call(address);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LocationTextfield(
              controller: _addressController,
              labelText: AppString.address,
              hintText: AppString.enterAddress,
              validator: AppValidators.validateAddress,
            ),

            SizedBox(height: 16.h),

            LocationTextfield(
              controller: _phoneController,
              labelText: AppString.phoneNumber,
              hintText: AppString.enterPhoneNumber,
              keyboardType: TextInputType.phone,
              validator: AppValidators.phoneValidator,
            ),

            SizedBox(height: 16.h),

            LocationTextfield(
              controller: _nameController,
              labelText: AppString.recipient,
              hintText: AppString.enterRecipient,
              validator: AppValidators.validateRecipientName,
            ),

            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: LocationTextfield(
                    controller: _cityController,
                    labelText: AppString.city,
                    hintText: AppString.city,
                    validator: AppValidators.validateCity,
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: LocationTextfield(
                    controller: _areaController,
                    labelText: AppString.area,
                    hintText: AppString.area,
                    validator: AppValidators.validateArea,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            BlocBuilder<AddressViewModel, AddressState>(
              builder: (context, state) {
                final isLoadingLocation =
                    state.locationState.isLoading ||
                    state.addressState.isLoading;

                final isUpdateWithNoChanges =
                    widget.address != null &&
                    !_hasFormChanges;

                final isDisabled =
                    isLoadingLocation ||
                    isUpdateWithNoChanges;

                return ElevatedButton(
                  onPressed: isDisabled ? null : _submitForm,
                  child: Text(
                    AppString.savedAddresses,
                    style: TextStyle(
                      color: context.colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}