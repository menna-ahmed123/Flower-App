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

  factory RegisterResult.fromOperationJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    return RegisterResult(
      userId: dataMap['userId']?.toString() ?? '',
      email: dataMap['email']?.toString() ?? '',
      role: dataMap['role']?.toString() ?? '',
      status: dataMap['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [userId, email, role, status, message];
}
