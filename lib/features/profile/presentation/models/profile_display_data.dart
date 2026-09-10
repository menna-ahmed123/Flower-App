import 'package:equatable/equatable.dart';

class ProfileDisplayData extends Equatable {
  const ProfileDisplayData({
    required this.name,
    required this.email,
    this.photoUrl,
  });

  final String name;
  final String email;
  final String? photoUrl;

  /// Temporary mock data used until a real Profile data source is wired in.
  static const ProfileDisplayData mock = ProfileDisplayData(
    name: 'Nour',
    email: 'Nour_Mohamed@gmail.com',
  );

  @override
  List<Object?> get props => [name, email, photoUrl];
}
