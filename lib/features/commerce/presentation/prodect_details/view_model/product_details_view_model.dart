import 'dart:developer';

import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_details_use_case.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_event.dart';
import 'package:flower_app/features/commerce/presentation/prodect_details/view_model/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsViewModel extends Cubit<ProductDetailsState> {
  final ProductDetailsUseCase _productDetailsUseCase;

  ProductDetailsViewModel(this._productDetailsUseCase)
    : super(const ProductDetailsState()) {
    log('ProductDetailsViewModel CREATED', name: 'ProductDetailsViewModel');
  }

  void onEvent(ProductDetailsEvent event) {
    log(
      'EVENT RECEIVED: ${event.runtimeType}',
      name: 'ProductDetailsViewModel',
    );

    if (event is GetProductDetailsEvent) {
      log('PRODUCT ID: ${event.productId}', name: 'ProductDetailsViewModel');

      _getProductDetails(event.productId);
    }
  }

  Future<void> _getProductDetails(String productId) async {
    log('START GET PRODUCT DETAILS', name: 'ProductDetailsViewModel');

    emit(
      state.copyWith(
        productDetailsState: state.productDetailsState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    log('LOADING STATE EMITTED', name: 'ProductDetailsViewModel');

    final BaseResponse<ProductDetailsEntity> productResponse =
        await _productDetailsUseCase(productId: productId);

    log(
      'RESPONSE RECEIVED: ${productResponse.runtimeType}',
      name: 'ProductDetailsViewModel',
    );

    switch (productResponse) {
      case SuccessResponse<ProductDetailsEntity>():
        final product = productResponse.data;

        log('SUCCESS', name: 'ProductDetailsViewModel');

        log('Product ID: ${product.id}', name: 'ProductDetailsViewModel');

        log('Product Name: ${product.name}', name: 'ProductDetailsViewModel');

        log('Product Price: ${product.price}', name: 'ProductDetailsViewModel');

        log(
          'Product In Stock: ${product.inStock}',
          name: 'ProductDetailsViewModel',
        );

        log(
          'Included Items: ${product.includedItems?.length ?? 0}',
          name: 'ProductDetailsViewModel',
        );

        emit(
          state.copyWith(
            productDetailsState: state.productDetailsState.copyWith(
              isLoading: false,
              data: product,
            ),
          ),
        );

        log('SUCCESS STATE EMITTED', name: 'ProductDetailsViewModel');

      case ErrorResponse<ProductDetailsEntity>():
        log('ERROR', name: 'ProductDetailsViewModel');

        log(
          'Error Message: ${productResponse.errorMessage}',
          name: 'ProductDetailsViewModel',
        );

        emit(
          state.copyWith(
            productDetailsState: state.productDetailsState.copyWith(
              isLoading: false,
              errorMessage: productResponse.errorMessage,
            ),
          ),
        );

        log('ERROR STATE EMITTED', name: 'ProductDetailsViewModel');
    }
  }
}
