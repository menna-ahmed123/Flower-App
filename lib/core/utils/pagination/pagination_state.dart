import 'package:equatable/equatable.dart';

enum PaginationStatus {
  initial,
  loading,
  success,
  loadingMore,
  error,
  errorLoadingMore,
}
class PaginationState<T> extends Equatable {
  final List<T> items;
  final PaginationStatus status;
  final String? errorMessage;
  final bool hasMore;

  const PaginationState({
    this.items = const [],
    this.status = PaginationStatus.initial,
    this.errorMessage,
    this.hasMore = true,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    PaginationStatus? status,
    String? errorMessage,
    bool? hasMore,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        items,
        status,
        errorMessage,
        hasMore,
      ];
}