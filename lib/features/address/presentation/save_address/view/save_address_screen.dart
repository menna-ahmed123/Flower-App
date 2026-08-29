import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/save_address/view/widgets/saved_address_body.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_event.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_view_model.dart';
import 'package:flower_app/features/auth/login/presentation/view/pages/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SaveAddressScreen extends StatelessWidget {
  const SaveAddressScreen({super.key});

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
        child: BlocConsumer<SaveAddressViewModel, SaveAddressState>(
          listener: (context, state) {
            if (state.actionError.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.actionError)));
            }
          },
          builder: (context, state) {
            return SavedAddressBody(
              isLoading: state.addressesState.isLoading,
              errorMessage: state.addressesState.errorMessage,
              addresses: state.addressesState.data ?? [],
              deletingId: state.deletingId,
              onRetry: () {
                context.read<SaveAddressViewModel>().doEvent(
                  LoadSavedAddresses(),
                );
              },

              onDelete: (id) {
                context.read<SaveAddressViewModel>().doEvent(
                  DeleteSavedAddress(id),
                );
              },
              onEdit: (address) {
                if (address.id != null && address.id!.isNotEmpty) {
                  context.read<SaveAddressViewModel>().doEvent(
                    EditSavedAddress(address.id!),
                  );
                }

                context.push<AddressEntity>(AppRoutesName.address);
              },
              onAddNew: () async {
                final address = await context.push<AddressEntity>(
                  AppRoutesName.address,
                );

                if (address != null && context.mounted) {
                  context.read<SaveAddressViewModel>().doEvent(
                    AddSavedAddress(address),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
