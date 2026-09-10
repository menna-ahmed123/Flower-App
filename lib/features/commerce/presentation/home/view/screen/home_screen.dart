import 'package:flower_app/core/widgets/app_shimmer/home_shimmer.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_event.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_state.dart';
import 'package:flower_app/features/address/presentation/default_address_view_model/default_address_view_model.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_list.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AddressEntity? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, homeState) {
            return BlocBuilder<DefaultAddressViewModel, DefaultAddressState>(
              builder: (context, addressState) {
                return _buildBody(context, homeState, addressState);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    HomeState state,
    DefaultAddressState addressState,
  ) {
    final home = state.homeState;

    if (home.isLoading && home.data == null) {
      return _loading(context);
    }

    if (home.errorMessage.isNotEmpty && home.data == null) {
      return _error(context, home.errorMessage);
    }

    final addresses = addressState.defaultAddressesState.data ?? [];
    AddressEntity? displayedAddress = _selectedAddress;
    if (displayedAddress == null && addresses.isNotEmpty) {
      displayedAddress = addresses.firstWhere(
        (address) => address.isDefault,
        orElse: () => addresses.first,
      );
    }
    return HomeSectionList(
      sections: context.read<HomeViewModel>().displayedSections,

      addresses: addresses,
      selectedAddress: displayedAddress,
      onAddressSelected: (address) {
        setState(() {
          _selectedAddress = address;
        });

        if (address.id != null) {
          context.read<DefaultAddressViewModel>().doEvent(
            SetDefaultAddress(address.id!),
          );
        }
      },
      onAddNewAddress: () async {
        final result = await context.push(AppRoutesName.saveAddress);

        if (!context.mounted) return;

        if (result == true) {
          setState(() {
            _selectedAddress = null;
          });

          context.read<DefaultAddressViewModel>().doEvent(LoadSavedAddresses());
        }
      },

      onQuery: (query) {
        context.read<HomeViewModel>().doEvent(HomeQueryChanged(query));
      },
    );
  }

  Widget _loading(BuildContext context) {
    return const HomeShimmer();
  }

  Widget _error(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 12.h),
            _retry(context),
          ],
        ),
      ),
    );
  }

  Widget _retry(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<HomeViewModel>().doEvent(HomeRequested());
      },
      child: const Text(AppString.retry),
    );
  }
}
