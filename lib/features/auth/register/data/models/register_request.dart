import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'FirstName')
  final String firstName;
  @JsonKey(name: 'LastName')
  final String lastName;
  final String email;
  final String phone;
  final int gender;
  final String password;
  final String confirmPassword;
  final String? deviceId;
  final String? fcmToken;
  final int notificationStatus;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.password,
    required this.confirmPassword,
    this.deviceId,
    this.fcmToken,
    this.notificationStatus = 0,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
