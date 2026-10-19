import 'package:equatable/equatable.dart';

sealed class MyOrdersUiEvent extends Equatable {
  const MyOrdersUiEvent();
  @override
  List<Object?> get props => [];
}

class TrackMyOrder extends MyOrdersUiEvent {
  final String orderId;
  const TrackMyOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class Reorder extends MyOrdersUiEvent {
  final String orderId;
  const Reorder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class ShowErrorMessage extends MyOrdersUiEvent {
  final String message;
  const ShowErrorMessage(this.message);
  @override
  List<Object?> get props => [message];
}

class RetryRequest extends MyOrdersUiEvent {
  @override
  List<Object?> get props => [];
}
