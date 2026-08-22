import 'package:equatable/equatable.dart';

class IncludedItemEntity extends Equatable {
  final String? name;
  final int? quantity;

  const IncludedItemEntity({this.name, this.quantity});

  @override
  List<Object?> get props => [name, quantity];
}
