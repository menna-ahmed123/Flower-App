import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_form.dart';
import 'package:flower_app/features/address/presentation/new_address/view/widgets/location_map.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: AppString.address),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LocationMap(
                    initialLocation: LatLng(30.0444, 31.2357),
                    onLocationSelected: (location) {
                      // handle location
                    },
                  ),
                ),
              ),
              LocationForm(onSave: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
