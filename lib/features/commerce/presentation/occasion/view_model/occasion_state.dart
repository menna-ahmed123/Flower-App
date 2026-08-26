import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

class OccasionState extends Equatable {
  final BaseState<List<OccasionModel>> occasionsState;
  final BaseState<List<ProductEntity>> productsState;
  final String selectedTab;

  const OccasionState({
    this.occasionsState = const BaseState(),
    this.productsState = const BaseState(),
    this.selectedTab = '',
  });

  OccasionState copyWith({
    BaseState<List<OccasionModel>>? occasionsState,
    BaseState<List<ProductEntity>>? productsState,
    String? selectedTab,
  }) {
    return OccasionState(
      occasionsState: occasionsState ?? this.occasionsState,
      productsState: productsState ?? this.productsState,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [occasionsState, productsState, selectedTab];
}