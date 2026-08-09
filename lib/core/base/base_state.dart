class BaseState<T> {
  final bool isLoading;
  final String errorMessage;
  final T? data;
  const BaseState({this.isLoading = false, this.errorMessage = '', this.data});

  BaseState<T> copyWith({bool? isLoading, String? errorMessage, T? data}) {
    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}