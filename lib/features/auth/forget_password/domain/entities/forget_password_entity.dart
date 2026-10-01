import 'package:equatable/equatable.dart';

class ForgetPasswordEntity extends Equatable {
  final bool success;

  const ForgetPasswordEntity({required this.success});

  @override
  List<Object?> get props => [success];
}
