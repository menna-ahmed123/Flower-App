import 'package:flower_app/core/constants/app_constants.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/domain/entities/location_entity.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_event.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_state.dart';
import 'package:flower_app/features/address/presentation/new_address/view_model/address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatefulWidget {
  final LocationEntity? initialLocation;
  final ValueChanged<LocationEntity>? onLocationSelected;

  const LocationMap({
    super.key,
    this.initialLocation,
    this.onLocationSelected,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  final MapController _mapController = MapController();
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _syncSelectedLocation(widget.initialLocation);
  }

  @override
  void didUpdateWidget(covariant LocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.initialLocation;
    if (next == null || next == oldWidget.initialLocation) return;

    setState(() {
      _syncSelectedLocation(next);
    });

    if (selectedLocation != null) {
      _mapController.move(selectedLocation!, 15);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _syncSelectedLocation(LocationEntity? location) {
    if (location == null) return;
    selectedLocation = LatLng(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final marker = selectedLocation ?? const LatLng(30.0444, 31.2357);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: marker,
              initialZoom: 14,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });

                widget.onLocationSelected?.call(
                  LocationEntity(
                    latitude: point.latitude,
                    longitude: point.longitude,
                  ),
                );
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    '${AppConstants.mapTilerBaseUrl}?key=${AppConstants.mapTilerApiKey}&language=en',
                userAgentPackageName:
                    AppConstants.mapUserAgentPackageName,
              ),
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      width: 60.w,
                      height: 60.h,
                      child: Icon(
                        Icons.location_pin,
                        size: 45.sp,
                        color: context.colors.pink,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Re-center on current location button
          Positioned(
            right: 12.w,
            bottom: 12.h,
            child: FloatingActionButton.small(
              heroTag: 'my_location_btn',
              backgroundColor: context.colors.white,
              onPressed: () {
                context.read<AddressViewModel>().doEvent(GetCurrentAddress());
              },
              child: Icon(
                Icons.my_location,
                color: context.colors.pink,
              ),
            ),
          ),

          // Loading Overlay
          BlocBuilder<AddressViewModel, AddressState>(
            buildWhen: (previous, current) =>
                previous.locationState.isLoading !=
                    current.locationState.isLoading ||
                previous.locationState.errorMessage !=
                    current.locationState.errorMessage,
            builder: (context, state) {
              if (state.locationState.isLoading) {
                return Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.2),
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
                              color: Colors.black.withValues(alpha: 0.12),
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
                              AppString.gettingLocation,
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
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}