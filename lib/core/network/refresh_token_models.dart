import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_models.g.dart';

@JsonSerializable(createFactory: false)
class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

@JsonSerializable(createToJson: false)
class RefreshTokenResponse {
  const RefreshTokenResponse({
    this.status,
    this.code,
    this.message,
    this.data,
    this.pagination,
    this.errors,
  });

  final bool? status;
  final int? code;
  final String? message;
  final RefreshTokenData? data;
  final dynamic pagination;
  final dynamic errors;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class RefreshTokenData {
  const RefreshTokenData({required this.token, required this.refreshToken});

  final String token;
  final String refreshToken;

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataFromJson(json);
}
