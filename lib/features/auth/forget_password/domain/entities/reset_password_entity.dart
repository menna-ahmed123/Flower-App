class ResetPasswordEntity {
  final bool? isSuccess;
  final int? statusCode;
  final String? message;
  final List<String>? errors;

  const ResetPasswordEntity({
    this.isSuccess,
    this.statusCode,
    this.message,
    this.errors,
  });
}
