import 'package:equatable/equatable.dart';

class TrackingDriverEntity extends Equatable {
  const TrackingDriverEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.imageUrl,
  });
  final String id;
  final String name;
  final String phone;
  final String? imageUrl;

  @override
  List<Object?> get props => [id, name, phone, imageUrl];
}
