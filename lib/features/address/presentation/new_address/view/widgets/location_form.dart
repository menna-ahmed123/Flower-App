import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationForm extends StatefulWidget {
  final ValueChanged<AddressEntity>? onSave;
  final AddressEntity? address;

  const LocationForm({super.key, this.onSave, this.address});

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fillForm(widget.address);
  }

  @override
  void didUpdateWidget(covariant LocationForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.address != widget.address) {
      _fillForm(widget.address);
    }
  }

  void _fillForm(AddressEntity? address) {
    if (address == null) return;

    _addressController.text = address.address ?? '';
    _phoneController.text = address.phoneNumber ?? '';
    _nameController.text = address.recipientName ?? '';
    _cityController.text = address.city ?? '';
    _areaController.text = address.area ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final address = AddressEntity(
        address: _addressController.text,
        phoneNumber: _phoneController.text,
        recipientName: _nameController.text,
        city: _cityController.text,
        area: _areaController.text,
      );

      widget.onSave?.call(address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              validator: AppValidators.validatePhone,
            ),

            SizedBox(height: 16.h),

            LocationTextfield(
              controller: _nameController,
              labelText: AppString.recipient,
              hintText: AppString.enterRecipient,
              validator: AppValidators.validateRecipientName,
            ),

            SizedBox(height: 16.h),

            LocationTextfield(
              controller: _cityController,
              labelText: AppString.city,
              hintText: AppString.city,
              validator: AppValidators.validateCity,
            ),

            SizedBox(height: 16.h),

            LocationTextfield(
              controller: _areaController,
              labelText: AppString.area,
              hintText: AppString.area,
              validator: AppValidators.validateArea,
            ),

            SizedBox(height: 32.h),

            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                AppString.savedAddresses,
                style: TextStyle(
                  color: context.colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
