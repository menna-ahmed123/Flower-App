import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/drop_down.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/helpers/app_validators.dart';

class LocationForm extends StatefulWidget {
  final VoidCallback? onSave;

  const LocationForm({super.key, this.onSave});

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

  final List<String> _cities = ['Cairo', 'Giza', 'Alexandria'];
  final List<String> _areas = ['October', 'Maadi', 'Zayed', 'Nasr City'];

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSave?.call();
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
            // Address Custom Text Field
            LocationTextfield(
              controller: _addressController,
              labelText: AppString.address,
              hintText: AppString.enterAddress,
              validator: AppValidators.validateAddress,
            ),
            SizedBox(height: 16.h),

            // Phone Number Custom Text Field
            LocationTextfield(
              controller: _phoneController,
              labelText: AppString.phoneNumber,
              hintText: AppString.enterPhoneNumber,
              keyboardType: TextInputType.phone,
              validator: AppValidators.validatePhone,
            ),
            SizedBox(height: 16.h),

            // Recipient Name Custom Text Field
            LocationTextfield(
              controller: _nameController,
              labelText: AppString.recipient,
              hintText: AppString.enterRecipient,
              validator: AppValidators.validateRecipientName,
            ),
            SizedBox(height: 16.h),

            // City & Area Dropdown Row
            Row(
              children: [
                Expanded(
                  child: DropDown<String>(
                    labelText: AppString.city,
                    hintText: AppString.cairo,
                    value: _selectedCity,
                    validator: AppValidators.validateCity,
                    items: _cities
                        .map(
                          (city) =>
                              DropdownMenuItem(value: city, child: Text(city)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCity = val;
                      });
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: DropDown<String>(
                    labelText: AppString.area,
                    hintText: AppString.october,
                    value: _selectedArea,
                    validator: AppValidators.validateArea,
                    items: _areas
                        .map(
                          (area) =>
                              DropdownMenuItem(value: area, child: Text(area)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedArea = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Save Address Action Button
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
