import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

class SearchState extends Equatable {
  const SearchState({this.productsState = const BaseState(), this.query = ''});

  final BaseState<List<ProductEntity>> productsState;
  final String query;

  SearchState copyWith({
    BaseState<List<ProductEntity>>? productsState,
    String? query,
  }) {
    return SearchState(
      productsState: productsState ?? this.productsState,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [productsState, query];
}
