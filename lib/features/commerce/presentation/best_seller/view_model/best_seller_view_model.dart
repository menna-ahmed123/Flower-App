import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/utils/pagination/pagination_controller.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_event.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class BestSellerViewModel extends Cubit<BestSellerState> {
  final ProductUseCase productUseCase;

  late final PaginationController<ProductEntity> productsPaginationController;

  BestSellerViewModel(this.productUseCase) : super(const BestSellerState()) {
    productsPaginationController = PaginationController<ProductEntity>(
      pageSize: 20,
      fetchPage: _fetchProductsPage,
    );
  }

  void doEvent(BestSellerEvent event) {
    switch (event) {
      case BestSeller():
        productsPaginationController.reset();
    }
  }

  Future<List<ProductEntity>> _fetchProductsPage(int page, int pageSize) async {
    final response = await productUseCase(
      page: page,
      pageSize: pageSize,
    );

    switch (response) {
      case SuccessResponse<List<ProductEntity>>():
        return response.data;
      case ErrorResponse<List<ProductEntity>>():
        throw Exception(response.errorMessage);
    }
  }

  @override
  Future<void> close() {
    productsPaginationController.dispose();
    return super.close();
  }
}
