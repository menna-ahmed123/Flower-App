import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/helpers/app_validators.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/city_entity.dart';
import 'package:flower_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/drop_down.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_textfield.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_view_model.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _labelController = TextEditingController(
    text: 'home',
  );

  @override
  void initState() {
    super.initState();
    _fillForm(widget.address);
    _addressController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _nameController.addListener(_onFormChanged);
    _areaController.addListener(_onFormChanged);
    _labelController.addListener(_onFormChanged);
  }

  @override
  void didUpdateWidget(covariant LocationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.address != widget.address) {
      _fillForm(widget.address);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _areaController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _fillForm(AddressEntity? address) {
    if (address == null) return;

    final hasAddressLine = address.addressLine?.isNotEmpty ?? false;
    final hasAddress = address.address?.isNotEmpty ?? false;

    if (_addressController.text.isEmpty && (hasAddressLine || hasAddress)) {
      _addressController.text = address.addressLine ?? address.address ?? '';
    }
    if (_phoneController.text.isEmpty &&
        (address.phoneNumber?.isNotEmpty ?? false)) {
      _phoneController.text = address.phoneNumber ?? '';
    }
    if (_nameController.text.isEmpty &&
        (address.recipientName?.isNotEmpty ?? false)) {
      _nameController.text = address.recipientName ?? '';
    }
    if (_areaController.text.isEmpty && (address.area?.isNotEmpty ?? false)) {
      _areaController.text = address.area ?? '';
    }
    if (address.label != null && address.label!.isNotEmpty) {
      _labelController.text = address.label!;
    }
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _submitForm() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final addressVmState = context.read<AddressViewModel>().state;
    final selectedGov = addressVmState.selectedGovernorate;
    final selectedCity = addressVmState.selectedCity;

    if (selectedGov == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a governorate')),
      );
      return;
    }

    if (selectedCity == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a city')));
      return;
    }

    final original = widget.address;
    final locationData = addressVmState.locationState.data;

    final address = AddressEntity(
      id: original?.id,
      label: _labelController.text.trim().isNotEmpty
          ? _labelController.text.trim()
          : 'home',
      address: _addressController.text.trim(),
      addressLine: _addressController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      recipientName: _nameController.text.trim(),
      city: selectedCity.nameEn ?? selectedCity.nameAr ?? '',
      area: _areaController.text.trim(),
      governorateId: selectedGov.id ?? original?.governorateId ?? 1,
      cityId: selectedCity.id ?? original?.cityId ?? 1,
      latitude: original?.latitude ?? locationData?.latitude ?? 30.0444,
      longitude: original?.longitude ?? locationData?.longitude ?? 31.2357,
      isDefault: original?.isDefault ?? false,
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
            // Address
            LocationTextfield(
              controller: _addressController,
              labelText: AppString.address,
              hintText: AppString.enterAddress,
              validator: AppValidators.validateAddress,
            ),
            SizedBox(height: 16.h),

            // Phone
            LocationTextfield(
              controller: _phoneController,
              labelText: AppString.phoneNumber,
              hintText: AppString.enterPhoneNumber,
              keyboardType: TextInputType.phone,
              validator: AppValidators.phoneValidator,
            ),
            SizedBox(height: 16.h),

            // Recipient Name
            LocationTextfield(
              controller: _nameController,
              labelText: AppString.recipient,
              hintText: AppString.enterRecipient,
              validator: AppValidators.validateRecipientName,
            ),
            SizedBox(height: 16.h),

            // Governorate & City Dropdowns in a Row
            BlocBuilder<AddressViewModel, AddressState>(
              builder: (context, state) {
                final governorates = state.governoratesState.data ?? [];
                final isGovLoading = state.governoratesState.isLoading;
                final cities = state.citiesState.data ?? [];
                final isCitiesLoading = state.citiesState.isLoading;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropDown<GovernorateEntity>(
                        labelText: 'Governorate',
                        hintText: 'Governorate',
                        value: state.selectedGovernorate,
                        isLoading: isGovLoading,
                        items: governorates.map((gov) {
                          return DropdownMenuItem<GovernorateEntity>(
                            value: gov,
                            child: Text(
                              gov.nameEn ?? gov.nameAr ?? 'Governorate',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: context.colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          context.read<AddressViewModel>().doEvent(
                            SelectGovernorate(selected),
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: DropDown<CityEntity>(
                        labelText: AppString.city,
                        hintText: AppString.city,
                        value: state.selectedCity,
                        isLoading: isCitiesLoading,
                        enabled: state.selectedGovernorate != null,
                        items: cities.map((city) {
                          return DropdownMenuItem<CityEntity>(
                            value: city,
                            child: Text(
                              city.nameEn ?? city.nameAr ?? 'City',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: context.colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          context.read<AddressViewModel>().doEvent(
                            SelectCity(selected),
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.h),

            // Area & Label in a Row
            Row(
              children: [
                Expanded(
                  child: LocationTextfield(
                    controller: _areaController,
                    labelText: AppString.area,
                    hintText: AppString.area,
                    validator: AppValidators.validateArea,
                  ),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  child: DropDown<String>(
                    labelText: 'Label',
                    hintText: 'Home / Office',
                    value: _labelController.text.isEmpty
                        ? null
                        : _labelController.text,
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'home',
                        child: Text('Home'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'office',
                        child: Text('Office'),
                      ),
                    ],
                    onChanged: (selected) {
                      _labelController.text = selected ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Submit Button
            BlocBuilder<SaveAddressViewModel, SaveAddressState>(
              builder: (context, saveState) {
                final isSaving = saveState.saveAddressState.isLoading;

                return ElevatedButton(
                  onPressed: isSaving ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: isSaving
                      ? SizedBox(
                          width: 22.w,
                          height: 22.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: context.colors.white,
                          ),
                        )
                      : Text(
                          widget.address != null
                              ? 'Update Address'
                              : AppString.savedAddresses,
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
