import '../../../domain/entities/product_entity.dart';

sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);

  final String query;
}

class SearchSubmitted extends SearchEvent {
  const SearchSubmitted(this.query);

  final String query;
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}

class ProductSelected extends SearchEvent {
  const ProductSelected(this.product);

  final ProductEntity product;
}
