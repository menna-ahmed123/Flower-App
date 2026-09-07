
import 'package:flutter/material.dart';

import 'package:flower_app/core/theme/app_color.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

class BottomSheetAddress extends StatelessWidget {
  const BottomSheetAddress({
    super.key,
    required this.addresses,
    this.selectedAddressId,
  });

  static const String addNewAddress = 'add_new_address';

  final List<AddressEntity> addresses;
  final String? selectedAddressId;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .75,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Choose delivery address',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Select where you want your flowers delivered',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          Flexible(
            child: addresses.isEmpty
                ? _emptyState(context)
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final address = addresses[index];

                      final isSelected =
                          address.id == selectedAddressId;

                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, address);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFFF4F8)
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? context.colors.pink
                                  : Colors.grey.shade200,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFFEAF2),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color:
                                      context.colors.pink,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            address.recipientName ??
                                                'Unknown',
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                            style:
                                                const TextStyle(
                                              fontWeight:
                                                  FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),

                                        if (address.isDefault) ...[
                                          const SizedBox(width: 8),

                                          Container(
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal: 7,
                                              vertical: 3,
                                            ),
                                            decoration:
                                                BoxDecoration(
                                              color: context
                                                  .colors
                                                  .pink,
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                10,
                                              ),
                                            ),
                                            child: const Text(
                                              'Default',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      address.address ??
                                          'No address',
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      address.city ??
                                          'Unknown city',
                                      style: TextStyle(
                                        color:
                                            Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 200,
                                ),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? context.colors.pink
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? context.colors.pink
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 15,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(
                  context,
                  BottomSheetAddress.addNewAddress,
                );
              },
              icon: Icon(
                Icons.add,
                color: context.colors.pink,
              ),
              label: Text(
                'Add New Address',
                style: TextStyle(
                  color: context.colors.pink,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: context.colors.pink,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 45,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No saved addresses yet',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add an address to continue',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

