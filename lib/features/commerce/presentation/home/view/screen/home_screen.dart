import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';

import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_address_event.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_state.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_address_view_model.dart';

import 'package:flower_app/features/address/domain/entities/address_entity.dart';

import 'package:flower_app/features/commerce/presentation/home/view/widgets/home_section_list.dart';

import 'package:flower_app/features/commerce/presentation/home/view_model/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view_model/home_view_model.dart';

import 'package:flower_app/core/di/di.dart';
import 'package:flower_app/app/router/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DefaultAddressViewModel>()
        ..doEvent(
          LoadSavedAddresses(),
        ),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeViewModel, HomeState>(
            builder: (context, homeState) {
              return BlocBuilder<
                  DefaultAddressViewModel,
                  DefaultAddressState>(
                builder: (context, addressState) {
                  return _buildBody(
                    context,
                    homeState,
                    addressState,
                  );
                },
              );
            },
          ),
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
      return _error(
        context,
        home.errorMessage,
      );
    }

    final addresses =
        addressState.defaultAddressesState.data ?? [];

    AddressEntity? defaultAddress;

    for (final address in addresses) {
      if (address.isDefault) {
        defaultAddress = address;
        break;
      }
    }

    return HomeSectionList(
      sections: context
          .read<HomeViewModel>()
          .displayedSections,

      addresses: addresses,

      selectedAddress: defaultAddress,


      onAddressSelected: (address) {
        if (address.id == null) return;

        context
            .read<DefaultAddressViewModel>()
            .doEvent(
              SetDefaultAddress(
                address.id!,
              ),
            );
      },

      onAddNewAddress: () async {
        final result = await context.push(
                    AppRoutesName.saveAddress,
        );

        if (!context.mounted) return;

        if (result == true) {
          context
              .read<DefaultAddressViewModel>()
              .doEvent(
                LoadSavedAddresses(),
              );
        }
      },

      // Search
      onQuery: (query) {
        context
            .read<HomeViewModel>()
            .doEvent(
              HomeQueryChanged(query),
            );
      },
    );
  }

  Widget _loading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.pink,
      ),
    );
  }

  Widget _error(
    BuildContext context,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
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
        context
            .read<HomeViewModel>()
            .doEvent(
              HomeRequested(),
            );
      },
      child: const Text(
        AppString.retry,
      ),
    );
  }
}
