import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_form.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_map.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_view_model.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

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
        body: BlocListener<AddressViewModel, AddressState>(
          listener: (context, state) {
            if (state.isSaved) {
              context.pop(true);
            }
          },
          child: SingleChildScrollView(
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
                      initialLocation: const LatLng(30.0444, 31.2357),
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
                          context.read<AddressViewModel>().doEvent(
                            AddAddress(address),
                          );
                        } else {
                          context.read<AddressViewModel>().doEvent(
                            EditAddress(address),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
