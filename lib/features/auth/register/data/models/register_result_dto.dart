class RegisterResultDto {
  const RegisterResultDto({
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

  factory RegisterResultDto.fromJson(Map<String, dynamic> json) {
    return RegisterResultDto(
      userId: json['userId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  factory RegisterResultDto.fromOperationJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
    return RegisterResultDto(
      userId: dataMap['userId']?.toString() ?? '',
      email: dataMap['email']?.toString() ?? '',
      role: dataMap['role']?.toString() ?? '',
      status: dataMap['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
