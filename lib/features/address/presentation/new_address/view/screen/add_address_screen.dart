import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
<<<<<<< HEAD
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
=======
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddAddressScreen extends StatefulWidget {
<<<<<<< HEAD
  const AddAddressScreen({
    super.key,
    this.address,
  });
=======
  const AddAddressScreen({super.key, this.address});
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef

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
      if (widget.address != null) {
        return;
      }

      _getCurrentAddress();
    }
  }

  void _getCurrentAddress() {
    final address = widget.address;

    if (address != null) {
<<<<<<< HEAD
      context.read<AddressViewModel>().doEvent(
            LoadAddressDetails(address.id!),
          );
    } else {
      context.read<AddressViewModel>().doEvent(
            GetCurrentAddress(),
          );
=======
      context.read<AddressViewModel>().doEvent(LoadAddressDetails(address.id!));
    } else {
      context.read<AddressViewModel>().doEvent(GetCurrentAddress());
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
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
<<<<<<< HEAD
          title: const Text(
            AppString.location,
          ),
=======
          title: const Text(AppString.location),
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
<<<<<<< HEAD
              child: const Text(
                AppString.cancel,
              ),
=======
              child: const Text(AppString.cancel),
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onOpenSettings();
              },
<<<<<<< HEAD
              child: const Text(
                AppString.openSettings,
              ),
=======
              child: const Text(AppString.openSettings),
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
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
<<<<<<< HEAD
                final errorMessage =
                    state.locationState.errorMessage;

                if (errorMessage ==
                    AppString.locationServicesDisabled) {
                  _showLocationDialog(
                    message:
                        AppString.enableLocationDescription,
                    onOpenSettings: () {
                      context
                          .read<AddressViewModel>()
                          .openLocationSettings();
=======
                final errorMessage = state.locationState.errorMessage;

                if (errorMessage == AppString.locationServicesDisabled) {
                  _showLocationDialog(
                    message: AppString.enableLocationDescription,
                    onOpenSettings: () {
                      context.read<AddressViewModel>().openLocationSettings();
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
                    },
                  );
                }

                if (errorMessage ==
<<<<<<< HEAD
                    AppString
                        .locationPermissionPermanentlyDenied) {
                  _showLocationDialog(
                    message:
                        AppString.enableLocationDescription,
                    onOpenSettings: () {
                      context
                          .read<AddressViewModel>()
                          .openAppSettings();
=======
                    AppString.locationPermissionPermanentlyDenied) {
                  _showLocationDialog(
                    message: AppString.enableLocationDescription,
                    onOpenSettings: () {
                      context.read<AddressViewModel>().openAppSettings();
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
                    },
                  );
                }
              },
            ),
<<<<<<< HEAD

            // ============================
           BlocListener<SaveAddressViewModel, SaveAddressState>(
  listener: (context, state) {
    // Success
    if (state.isSaved) {
      context.pop(true);
      return;
    }

    final errorMessage =
        state.saveAddressState.errorMessage;

    final isLoading =
        state.saveAddressState.isLoading;

    if (!isLoading && errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  },
),
          ],

          child: BlocBuilder<AddressViewModel, AddressState>(
            builder: (context, state) {
              final location =
                  state.locationState.data ??
                      const LocationEntity(
                        latitude: 30.0444,
                        longitude: 31.2357,
                      );

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // ============================
                    // Location Loading
                    // ============================
                    BlocBuilder<AddressViewModel, AddressState>(
                      buildWhen: (previous, current) {
                        return previous.locationState.isLoading !=
                            current.locationState.isLoading;
                      },
                      builder: (context, state) {
                        if (state.locationState.isLoading) {
                          return const LinearProgressIndicator();
                        }
=======
            BlocListener<SaveAddressViewModel, SaveAddressState>(
              listener: (context, state) {
                // Success
                if (state.isSaved) {
                  context.pop(true);
                  return;
                }
                final errorMessage = state.saveAddressState.errorMessage;

                final isLoading = state.saveAddressState.isLoading;

                if (!isLoading && errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef

                        return const SizedBox.shrink();
                      },
                    ),
<<<<<<< HEAD

                    // ============================
                    // Map
                    // ============================
=======
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
                    SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: LocationMap(
                          initialLocation: location,
                          onLocationSelected: (location) {
<<<<<<< HEAD
                            context
                                .read<AddressViewModel>()
                                .doEvent(
                                  LocationSelected(
                                    latitude:
                                        location.latitude,
                                    longitude:
                                        location.longitude,
                                  ),
                                );
=======
                            context.read<AddressViewModel>().doEvent(
                              LocationSelected(
                                latitude: location.latitude,
                                longitude: location.longitude,
                              ),
                            );
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
                          },
                        ),
                      ),
                    ),

                    BlocBuilder<AddressViewModel, AddressState>(
                      buildWhen: (previous, current) {
                        return previous.addressState.data !=
                                current.addressState.data ||
                            previous.addressState.isLoading !=
                                current.addressState.isLoading;
                      },
                      builder: (context, state) {
                        return LocationForm(
                          address: state.addressState.data,

                          onSave: (address) {
<<<<<<< HEAD
                            final saveViewModel =
                                context.read<
                                    SaveAddressViewModel>();
                            if (widget.address == null) {
                              saveViewModel.doEvent(
                                AddAddress(address),
                              );
                              return;
                            }
                            saveViewModel.doEvent(
                              EditAddress(address),
                            );
=======
                            final saveViewModel = context
                                .read<SaveAddressViewModel>();
                            if (widget.address == null) {
                              saveViewModel.doEvent(AddAddress(address));
                              return;
                            }
                            saveViewModel.doEvent(EditAddress(address));
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
                          },
                        );
                      },
                    ),

<<<<<<< HEAD
                    const SizedBox(
                      height: 20,
                    ),
=======
                    const SizedBox(height: 20),
>>>>>>> 9cfe7ae3245a3e8fd580de837b8f1322469da9ef
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
