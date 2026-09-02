import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/core/widgets/app_button.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/presentation/save_address/view/widgets/address_card.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_state.dart';
import 'package:flower_app/features/address/presentation/save_address/view_model/save_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedAddressesBody extends StatelessWidget {
  const SavedAddressesBody({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.addresses,
    required this.onRetry,
    required this.onDelete,
    required this.onEdit,
    required this.onAddNew,
  });

  final bool isLoading;
  final String errorMessage;
  final List<AddressEntity> addresses;
  final VoidCallback onRetry;
  final ValueChanged<String> onDelete;
  final ValueChanged<AddressEntity> onEdit;
  final VoidCallback onAddNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(errorMessage, textAlign: TextAlign.center),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: onRetry,
                        child: const Text(AppString.retry),
                      ),
                    ],
                  ),
                )
              : addresses.isEmpty
              ? Center(
                  child: Text(
                    AppString.noData,
                    style: TextStyle(
                      color: context.colors.grey.shade800,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                  itemCount: addresses.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    final id = address.id ?? '';

                   return BlocSelector<SaveAddressViewModel, SaveAddressState, bool>(
  selector: (state) {
    return state.deletingId == id && id.isNotEmpty;
  },
  builder: (context, isDeleting) {
    return AddressCard(
      address: address,
      isDeleting: isDeleting,
      onDelete: id.isEmpty ? null : () => onDelete(id),
      onEdit: () => onEdit(address),
    );
  },
);
                  },
                ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: AppButton(text: AppString.newAddress, onPressed: onAddNew),
        ),
      ],
    );
  }
}
