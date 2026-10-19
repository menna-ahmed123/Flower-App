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
import 'package:flower_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, this.address});

  final AddressEntity? address;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initData();
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
      _initData();
    }
  }

  void _initData() {
    final address = widget.address;
    final addressVm = context.read<AddressViewModel>();

    // Load governorates
    addressVm.doEvent(LoadGovernorates());

    if (address != null && address.id != null && address.id!.isNotEmpty) {
      addressVm.doEvent(LoadAddressDetails(address.id!));
    } else {
      addressVm.doEvent(GetCurrentAddress());
    }
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
          title: widget.address != null ? 'Edit Address' : AppString.address,
          onBack: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AddressViewModel, AddressState>(
              listenWhen: (previous, current) {
                return previous.locationState.errorMessage !=
                    current.locationState.errorMessage;
              },
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

                if (errorMessage ==
                    AppString.locationPermissionPermanentlyDenied) {
                  _showLocationDialog(
                    message: AppString.enableLocationDescription,
                    onOpenSettings: () {
                      context.read<AddressViewModel>().openAppSettings();
                    },
                  );
                }
              },
            ),
            BlocListener<SaveAddressViewModel, SaveAddressState>(
              listener: (context, state) {
                if (state.isSaved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.address != null
                            ? 'Address updated successfully'
                            : 'Address saved successfully',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop(true);
                  return;
                }

                final errorMessage = state.saveAddressState.errorMessage;
                final isLoading = state.saveAddressState.isLoading;

                if (!isLoading && errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
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
                        padding: const EdgeInsets.all(16),
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
                      buildWhen: (previous, current) {
                        return previous.addressState.data !=
                                current.addressState.data ||
                            previous.addressState.isLoading !=
                                current.addressState.isLoading ||
                            previous.governoratesState !=
                                current.governoratesState ||
                            previous.citiesState != current.citiesState ||
                            previous.selectedGovernorate !=
                                current.selectedGovernorate ||
                            previous.selectedCity != current.selectedCity;
                      },
                      builder: (context, state) {
                        return LocationForm(
                          address: state.addressState.data ?? widget.address,
                          onSave: (address) {
                            final saveViewModel =
                                context.read<SaveAddressViewModel>();

                            if (widget.address == null) {
                              saveViewModel.doEvent(AddAddress(address));
                              return;
                            }

                            saveViewModel.doEvent(EditAddress(address));
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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
