import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String role;
  final int expiresIn;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.expiresIn,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, role, expiresIn];
}