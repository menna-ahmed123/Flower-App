import 'package:equatable/equatable.dart';
import 'package:flower_app/core/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/home_layout_entity.dart';

class HomeState extends Equatable {
  const HomeState({
    this.homeState = const BaseState(),
    this.shouldShowNotificationSettingsDialog = false,
  });

  final BaseState<HomeLayoutEntity> homeState;
  final bool shouldShowNotificationSettingsDialog;

  HomeState copyWith({
    BaseState<HomeLayoutEntity>? homeState,
    bool? shouldShowNotificationSettingsDialog,
  }) {
    return HomeState(
      homeState: homeState ?? this.homeState,
      shouldShowNotificationSettingsDialog:
          shouldShowNotificationSettingsDialog ??
          this.shouldShowNotificationSettingsDialog,
    );
  }

  @override
  List<Object?> get props => [homeState, shouldShowNotificationSettingsDialog];
}
