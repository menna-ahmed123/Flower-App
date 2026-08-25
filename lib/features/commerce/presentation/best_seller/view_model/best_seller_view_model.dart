import 'package:flower_app/core/base/base_response.dart';
import 'package:flower_app/features/commerce/domain/entities/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_cases/product_use_case.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_event.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/view_model/best_seller_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class BestSellerViewModel extends Cubit<BestSellerState> {
  final ProductUseCase productUseCase;

  BestSellerViewModel(this.productUseCase): super(const BestSellerState());

void doEvent(BestSellerEvent event) {
  switch(event){
    case BestSeller():
    _getAllProducts();
    break;
  }
}

  Future<void>_getAllProducts()async{
    emit(state.copyWith(
      bestSellState: state.bestSellState.copyWith(
       isLoading: true,
       errorMessage: "", 
      )
    ));
    final response=await productUseCase();
    switch (response) {
  case SuccessResponse<List<ProductEntity>>():
    emit(state.copyWith(
      bestSellState: state.bestSellState.copyWith(
        isLoading: false,
        data: response.data,
        errorMessage: '',
      ),
    ));
    break;

  case ErrorResponse():
    emit(state.copyWith(
      bestSellState: state.bestSellState.copyWith(
        isLoading: false,
        errorMessage: response.errorMessage,
      ),
    ));
    break;
}
  }

}