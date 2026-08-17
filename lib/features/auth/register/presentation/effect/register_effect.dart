import 'package:equatable/equatable.dart';

sealed class RegisterEffect extends Equatable {
  const RegisterEffect();
}

final class NavigateToLoginEffect extends RegisterEffect {
  const NavigateToLoginEffect({this.successMessage});

  final String? successMessage;

  @override
  List<Object?> get props => [successMessage];
}

final class NavigateBackEffect extends RegisterEffect {
  const NavigateBackEffect();

  @override
  List<Object?> get props => [];
}

final class ShowErrorMessageEffect extends RegisterEffect {
  const ShowErrorMessageEffect(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
