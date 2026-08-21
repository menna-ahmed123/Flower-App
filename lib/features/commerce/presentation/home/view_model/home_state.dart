import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';

class HomeState extends Equatable {
  const HomeState({this.homeState = const BaseState(), this.query = ''});

  final BaseState<HomeLayoutEntity> homeState;
  final String query;

  HomeState copyWith({BaseState<HomeLayoutEntity>? homeState, String? query}) {
    return HomeState(
      homeState: homeState ?? this.homeState,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [homeState, query];
}
