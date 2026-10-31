import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';

class OccasionState extends Equatable {
  final BaseState<List<OccasionModel>> occasionsState;
  final String selectedTab;
  final String selectedOccasionId;

  const OccasionState({
    this.occasionsState = const BaseState(),
    this.selectedTab = '',
    this.selectedOccasionId = '',
  });

  OccasionState copyWith({
    BaseState<List<OccasionModel>>? occasionsState,
    String? selectedTab,
    String? selectedOccasionId,
  }) {
    return OccasionState(
      occasionsState: occasionsState ?? this.occasionsState,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedOccasionId: selectedOccasionId ?? this.selectedOccasionId,
    );
  }

  @override
  List<Object?> get props => [occasionsState, selectedTab, selectedOccasionId];
}
