import 'package:equatable/equatable.dart';

class RegisterResult extends Equatable {
  const RegisterResult({
    required this.userId,
    required this.email,
    required this.role,
    required this.status,
    this.message = '',
  });

  final String userId;
  final String email;
  final String role;
  final String status;
  final String message;

  @override
  List<Object?> get props => [userId, email, role, status, message];
}
