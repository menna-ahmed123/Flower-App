import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_address_event.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_state.dart';
import 'package:flower_app/core/utils/commerce_widgets/default_address_view_model/default_address_view_model.dart';
import 'package:flower_app/features/address/presentation/save_address/view/widgets/saved_address_body.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_view_model.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.savedAddresses,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutesName.profile);
          }
        },
      ),
      body: SafeArea(
        child: BlocListener<SaveAddressViewModel, SaveAddressState>(
          listener: (context, state) {
            if (state.actionError.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionError),
                ),
              );
            }
          },
          child: BlocBuilder<DefaultAddressViewModel, DefaultAddressState>(
            buildWhen: (previous, current) {
              return previous.addressesState != current.addressesState;
            },
            builder: (context, state) {
              return SavedAddressesBody(
                isLoading: state.addressesState.isLoading,
                errorMessage: state.addressesState.errorMessage,
                addresses: state.addressesState.data ?? [],

                // Retry
                onRetry: () {
                  context.read<DefaultAddressViewModel>().doEvent(
                        LoadSavedAddresses(),
                      );
                },

                // Delete
                onDelete: (id) {
                  context.read<SaveAddressViewModel>().doEvent(
                        DeleteSavedAddress(id),
                      );
                },

                // Edit
                onEdit: (address) async {
                  final result = await context.push(
                    AppRoutesName.address,
                    extra: address,
                  );

                  if (result == true && context.mounted) {
                    context.read<DefaultAddressViewModel>().doEvent(
                          LoadSavedAddresses(),
                        );
                  }
                },

                // Add New Address
                onAddNew: () async {
                  final result = await context.push(
                    AppRoutesName.address,
                  );

                  if (result == true && context.mounted) {
                    context.read<DefaultAddressViewModel>().doEvent(
                          LoadSavedAddresses(),
                        );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}