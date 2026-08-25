import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_details_use_case.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_event.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ProductDetailsViewModel extends Cubit<ProductDetailsState> {
  final ProductDetailsUseCase _productDetailsUseCase;

  ProductDetailsViewModel(this._productDetailsUseCase)
    : super(const ProductDetailsState());

 Future<void> onEvent(ProductDetailsEvent event) async {
    if (event is GetProductDetailsEvent) {
      await _getProductDetails(event.productId);
    }
  }

  Future<void> _getProductDetails(String productId) async {
    emit(
      state.copyWith(
        productDetailsState: state.productDetailsState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final BaseResponse<ProductDetailsEntity> productResponse =
        await _productDetailsUseCase(productId: productId);

    switch (productResponse) {
      case SuccessResponse<ProductDetailsEntity>():
        final product = productResponse.data;

        emit(
          state.copyWith(
            productDetailsState: state.productDetailsState.copyWith(
              isLoading: false,
              data: product,
            ),
          ),
        );

      case ErrorResponse<ProductDetailsEntity>():
        emit(
          state.copyWith(
            productDetailsState: state.productDetailsState.copyWith(
              isLoading: false,
              errorMessage: productResponse.errorMessage,
            ),
          ),
        );
    }
  }
}
