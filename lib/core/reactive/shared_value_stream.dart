import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// One shared stream that replays the latest value to every new listener.
final class SharedValueStream<T> {
  final _subject = BehaviorSubject<T>();
  StreamSubscription<T>? _subscription;

  bool get hasValue => _subject.hasValue;

  T? get valueOrNull => _subject.hasValue ? _subject.value : null;

  void add(T value) => _subject.add(value);

  /// Subscribes to [open] once. Later calls replay the cached value.
  Stream<T> watch(
    Stream<T> Function() open, {
    required Object Function(Object error) mapError,
  }) {
    _subscription ??= open().listen(
      _subject.add,
      onError: (Object error, StackTrace stackTrace) {
        _subject.addError(mapError(error), stackTrace);
      },
    );
    if (_subject.hasError && !_subject.hasValue) {
      return Stream<T>.error(_subject.error, _subject.stackTrace);
    }
    return _subject.stream;
  }
}
