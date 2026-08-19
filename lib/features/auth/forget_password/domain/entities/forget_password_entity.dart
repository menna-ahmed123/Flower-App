import 'package:equatable/equatable.dart';

class ForgetPasswordEntity extends Equatable {
  final int cooldownRemainingSeconds;

  const ForgetPasswordEntity({required this.cooldownRemainingSeconds});

  @override
  List<Object?> get props => [cooldownRemainingSeconds];
}
