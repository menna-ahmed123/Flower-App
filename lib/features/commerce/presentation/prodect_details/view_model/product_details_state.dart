import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_details_state.freezed.dart';

@freezed
abstract class ProductDetailsState with _$ProductDetailsState {
  const factory ProductDetailsState({
    @Default(BaseState<ProductDetailsEntity>())
    BaseState<ProductDetailsEntity> productDetailsState,
  }) = _ProductDetailsState;

  factory ProductDetailsState.initial() {
    return const ProductDetailsState(
      productDetailsState: BaseState<ProductDetailsEntity>(),
    );
  }
}
