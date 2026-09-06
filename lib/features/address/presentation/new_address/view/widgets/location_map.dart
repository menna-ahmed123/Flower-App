import 'package:flower_app/core/constants/app_constants.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatefulWidget {
  final LatLng initialLocation;
  final ValueChanged<LatLng>? onLocationSelected;

  const LocationMap({
    super.key,
    required this.initialLocation,
    this.onLocationSelected,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late LatLng selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: widget.initialLocation,
            initialZoom: 13,
            onTap: (tapPosition, point) {
              setState(() {
                selectedLocation = point;
              });

              widget.onLocationSelected?.call(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  '${AppConstants.mapTilerBaseUrl}?key=${AppConstants.mapTilerApiKey}&language=en',
              userAgentPackageName: AppConstants.mapUserAgentPackageName,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: selectedLocation,
                  width: 80,
                  height: 80,
                  child: Icon(
                    Icons.location_pin,
                    size: 50,
                    color: context.colors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),

        BlocBuilder<AddressViewModel, AddressState>(
          buildWhen: (previous, current) =>
              previous.locationState.isLoading !=
              current.locationState.isLoading,
          builder: (context, state) {
            if (!state.locationState.isLoading) {
              return const SizedBox.shrink();
            }
            
            return Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.15),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          spreadRadius: 2,
                          color: Colors.black.withOpacity(0.12),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 22.w,
                          height: 22.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: context.colors.pink,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Getting your location...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
