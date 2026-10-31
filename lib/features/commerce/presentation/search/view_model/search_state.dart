import 'package:equatable/equatable.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';

class SearchState extends Equatable {
  const SearchState({this.query = '', this.selectedProduct});

  final String query;
  final ProductEntity? selectedProduct;

  SearchState copyWith({String? query, ProductEntity? selectedProduct}) {
    return SearchState(
      query: query ?? this.query,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }

  @override
  List<Object?> get props => [query, selectedProduct];
}
