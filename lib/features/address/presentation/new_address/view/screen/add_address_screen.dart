import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_form.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_map.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_view_model.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_view_model.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, this.address});

  final AddressEntity? address;
  @override
  State<AddAddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddAddressScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getCurrentAddress();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (widget.address != null) return;

      _getCurrentAddress();
    }
  }

  void _getCurrentAddress() {
    final address = widget.address;
    if (address != null) {
      context.read<AddressViewModel>().doEvent(LoadAddressDetails(address.id!));
      return;
    }
    context.read<AddressViewModel>().doEvent(GetCurrentAddress());
  }
 void _showLocationDialog({
    required String message,
    required VoidCallback onOpenSettings,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppString.location),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppString.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onOpenSettings();
              },
              child: const Text(AppString.openSettings),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppString.address,
          onBack: () {
            if (context.canPop()) context.pop();
          },
        ),
        body: BlocListener<SaveAddressViewModel, SaveAddressState>(
          listener: (context, state) {
             final errorMessage = state.saveAddressState.errorMessage;

            if (errorMessage == AppString.locationServicesDisabled) {
              _showLocationDialog(
                message: AppString.enableLocationDescription,
                onOpenSettings: () {
                  context.read<AddressViewModel>().openLocationSettings();
                },
              );
            }

            if (errorMessage == AppString.locationPermissionPermanentlyDenied) {
              _showLocationDialog(
                message: AppString.enableLocationDescription,
                onOpenSettings: () {
                  context.read<AddressViewModel>().openAppSettings();
                },
              );
            }
            if (state.isSaved) {
              context.pop(true);
            }},
          child: BlocBuilder<AddressViewModel, AddressState>(
             builder: (context, state) {
              final location = state.locationState.data;

          return SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<AddressViewModel, AddressState>(
                  buildWhen: (previous, current) =>
                      previous.locationState.isLoading !=
                      current.locationState.isLoading,
                  builder: (context, state) {
                    if (state.locationState.isLoading) {
                      return const LinearProgressIndicator();
                    }

                    return const SizedBox.shrink();
                  },
                ),

                SizedBox(
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: LocationMap(
                      initialLocation: location,
                      onLocationSelected: (location) {
                        context.read<AddressViewModel>().doEvent(
                          LocationSelected(
                            latitude: location.latitude,
                            longitude: location.longitude,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                BlocBuilder<AddressViewModel, AddressState>(
                  buildWhen: (previous, current) =>
                      previous.addressState.data != current.addressState.data,
                  builder: (context, state) {
                    return LocationForm(
                      address: state.addressState.data,
                      onSave: (address) {
                        if (widget.address == null) {
                          context.read<SaveAddressViewModel>().doEvent(
                            AddAddress(address),
                          );
                        } else {
                          context.read<SaveAddressViewModel>().doEvent(
                            EditAddress(address),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            
          );
          },
        ),
      ),
    ));
  }
}
