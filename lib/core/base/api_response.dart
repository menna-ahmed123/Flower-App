class ApiResponse<T> {
  const ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
    this.pagination,
    this.errors,
  });

  final bool status;
  final int code;
  final String message;
  final T? data;
  final dynamic pagination;
  final dynamic errors;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'];

    return ApiResponse<T>(
      status: json['status'] as bool? ?? false,
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: rawData == null ? null : fromJsonT(rawData),
      pagination: json['pagination'],
      errors: json['errors'],
    );
  }

  String get errorMessage {
    if (errors == null) return message;
    return '$message\n${errors is Map ? errors.values.join('\n') : errors}';
  }
}