class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final String role;

  AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });
}
