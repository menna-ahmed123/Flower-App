import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/drop_down.dart';
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

  String? _selectedCity;
  String? _selectedArea;

  final List<String> _cities = ['Cairo', 'Giza', 'Alexandria', 'Sohag'];

  final List<String> _areas = ['Sohag', 'Akhnim', 'Girga', 'Tahta'];

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

    _selectedCity = _cities.contains(address.city) ? address.city : null;
    _selectedArea = _areas.contains(address.area) ? address.area : null;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final address = AddressEntity(
        address: _addressController.text,
        phoneNumber: _phoneController.text,
        recipientName: _nameController.text,
        city: _selectedCity,
        area: _selectedArea,
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

            Row(
              children: [
                Expanded(
                  child: DropDown<String>(
                    value: _selectedCity,
                    labelText: AppString.city,
                    hintText: AppString.city,
                    items: _cities
                        .map(
                          (city) => DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    validator: AppValidators.validateCity,
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: DropDown<String>(
                    value: _selectedArea,
                    labelText: AppString.area,
                    hintText: AppString.area,
                    items: _areas
                        .map(
                          (area) => DropdownMenuItem<String>(
                            value: area,
                            child: Text(area),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedArea = value;
                      });
                    },
                    validator: AppValidators.validateArea,
                  ),
                ),
              ],
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
