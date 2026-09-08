import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

class CartState extends Equatable {
  const CartState({this.cartState = const BaseState()});

  final BaseState<CartEntity> cartState;

  int get itemCount => cartState.data?.itemCount ?? 0;

  CartState copyWith({BaseState<CartEntity>? cartState}) {
    return CartState(cartState: cartState ?? this.cartState);
  }

  @override
  List<Object?> get props => [cartState];
}
