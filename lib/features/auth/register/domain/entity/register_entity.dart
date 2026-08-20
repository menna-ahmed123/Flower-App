import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String userId;
  final String email;
  final String role;
  final String status;
  final String message;

  const RegisterEntity({
    required this.userId,
    required this.email,
    required this.role,
    required this.status,
    this.message = '',
  });

  @override
  List<Object?> get props => [userId, email, role, status, message];
}
