import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

class BestSellerState extends Equatable {
  final BaseState<List<ProductEntity>> bestSellState;

  const BestSellerState({this.bestSellState = const BaseState()});

  @override
  List<Object?> get props => [bestSellState];

  BestSellerState copyWith({BaseState<List<ProductEntity>>? bestSellState}) {
    return BestSellerState(bestSellState: bestSellState ?? this.bestSellState);
  }
}