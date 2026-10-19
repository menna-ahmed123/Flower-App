import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UiEventCubit<S, E> extends Cubit<S> {
  UiEventCubit(super.initialState);

  final StreamController<E> _uiEvents = StreamController<E>.broadcast();

  Stream<E> get uiEvents => _uiEvents.stream;

  void emitUiEvent(E event) {
    if (_uiEvents.isClosed) return;
    _uiEvents.add(event);
  }

  @override
  Future<void> close() {
    _uiEvents.close();
    return super.close();
  }
}
