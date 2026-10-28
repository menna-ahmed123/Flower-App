import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/core/utils/pagination/pagination_controller.dart';
import 'package:flower_app/features/commerce/data/models/occasion_model.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/occasion_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_event.dart';
import 'package:flower_app/features/commerce/presentation/occasion/view_model/occasion_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OccasionViewModel extends Cubit<OccasionState> {
  OccasionViewModel(this.occasionUseCase, this.productUseCase)
    : super(const OccasionState()) {
    productsPaginationController = PaginationController<ProductEntity>(
      pageSize: 20,
      fetchPage: _fetchProductsPage,
    );
  }

  final OccasionUseCase occasionUseCase;
  final ProductUseCase productUseCase;

  late final PaginationController<ProductEntity> productsPaginationController;

  void onEvent(OccasionEvent event) {
    switch (event) {
      case LoadOccasions():
        _loadOccasions();
      case SelectOccasionTab():
        _loadProductsByOccasion(event.occasionId, event.tab);
    }
  }

  Future<void> _loadOccasions() async {
    emit(
      state.copyWith(
        occasionsState: state.occasionsState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await occasionUseCase();

    switch (response) {
      case SuccessResponse<List<OccasionModel>>():
        final data = response.data;
        final firstOccasion = data.isNotEmpty ? data.first : null;
        emit(
          state.copyWith(
            occasionsState: state.occasionsState.copyWith(
              isLoading: false,
              data: data,
              errorMessage: '',
            ),
            selectedTab: firstOccasion?.name ?? '',
          ),
        );

        if (firstOccasion != null) {
          _loadProductsByOccasion(firstOccasion.id, firstOccasion.name);
        }

      case ErrorResponse<List<OccasionModel>>():
        emit(
          state.copyWith(
            occasionsState: state.occasionsState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  void _loadProductsByOccasion(String occasionId, String tab) {
    // Reset pagination for the new occasion tab.
    productsPaginationController.reset();

    emit(state.copyWith(
      selectedTab: tab,
      selectedOccasionId: occasionId,
    ));
  }

  Future<List<ProductEntity>> _fetchProductsPage(int page, int pageSize) async {
    final response = await productUseCase(
      occasionId: state.selectedOccasionId,
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
