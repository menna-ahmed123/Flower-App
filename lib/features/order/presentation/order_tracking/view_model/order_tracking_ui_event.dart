import 'package:equatable/equatable.dart';

sealed class OrderTrackingUiEvent extends Equatable {
  const OrderTrackingUiEvent();

  @override
  List<Object?> get props => [];
}

class ShowTrackingMessage extends OrderTrackingUiEvent {
  const ShowTrackingMessage(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TrackingNavigateBack extends OrderTrackingUiEvent {
  const TrackingNavigateBack();
}
