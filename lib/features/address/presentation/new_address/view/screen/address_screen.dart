import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_view_model.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_form.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_map.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
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
      _getCurrentAddress();
    }
  }

  void _getCurrentAddress() {
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
        appBar: CustomAppBar(title: AppString.address),
        body: BlocListener<AddressViewModel, AddressState>(
          listener: (context, state) {
            final errorMessage = state.locationState.errorMessage;

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
          },
          child: BlocBuilder<AddressViewModel, AddressState>(
            builder: (context, state) {
              final location =
                  state.locationState.data ??
                  const LocationEntity(latitude: 30.0444, longitude: 31.2357);

              final isLoading =
                  state.locationState.isLoading || state.addressState.isLoading;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            LocationMap(
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

                            if (isLoading) const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                    LocationForm(
                      address: state.addressState.data,
                      onSave: (address) {
                        // address.address
                        // address.phoneNumber
                        // address.recipientName
                        // address.city
                        // address.area
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
