import 'package:flower_app/core/base/base_response.dart';
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
    : super(const OccasionState());

  final OccasionUseCase occasionUseCase;
  final ProductUseCase productUseCase;

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
          await _loadProductsByOccasion(firstOccasion.id, firstOccasion.name);
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

  Future<void> _loadProductsByOccasion(String occasionId, String tab) async {
    emit(
      state.copyWith(
        selectedTab: tab,
        productsState: state.productsState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await productUseCase(occasionId: occasionId);

    switch (response) {
      case SuccessResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsState: state.productsState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );

      case ErrorResponse<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsState: state.productsState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
