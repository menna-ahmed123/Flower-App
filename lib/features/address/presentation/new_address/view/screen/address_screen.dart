import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_view_model.dart';
import 'package:flower_app/features/address/presentation/new_address/view/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_form.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_map.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: AppString.address),
        body: BlocBuilder<AddressViewModel, AddressState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
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
    );
  }
}
