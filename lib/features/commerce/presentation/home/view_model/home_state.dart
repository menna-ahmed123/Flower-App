import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';

class HomeState extends Equatable {
  const HomeState({this.homeState = const BaseState()});

  final BaseState<HomeLayoutEntity> homeState;

  HomeState copyWith({BaseState<HomeLayoutEntity>? homeState}) {
    return HomeState(homeState: homeState ?? this.homeState);
  }

  @override
  List<Object?> get props => [homeState];
}
