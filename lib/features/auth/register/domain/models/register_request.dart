import 'package:equatable/equatable.dart';

enum Gender { female, male }

class RegisterRequest extends Equatable {
  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.gender,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final Gender gender;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    phoneNumber,
    gender,
  ];
}
