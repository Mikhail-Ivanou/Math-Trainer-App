import 'dart:async';

/// One shared stream that replays the latest value to every new listener.
///
/// The source is opened for the first listener and cancelled when the last
/// one leaves. A source that fails is not remembered: the next [watch] opens
/// it again.
final class SharedValueStream<T> {
  final _listeners = <MultiStreamController<T>>[];
  StreamSubscription<T>? _source;
  T? _value;
  var _hasValue = false;

  bool get hasValue => _hasValue;

  T? get valueOrNull => _hasValue ? _value : null;

  void add(T value) {
    _hasValue = true;
    _value = value;
    for (final listener in [..._listeners]) {
      listener.add(value);
    }
  }

  /// Subscribes to [open] while somebody is listening.
  Stream<T> watch(
    Stream<T> Function() open, {
    required Object Function(Object error) mapError,
    void Function()? onRelease,
  }) {
    return Stream<T>.multi((listener) {
      _listeners.add(listener);
      listener.onCancel = () {
        _listeners.remove(listener);
        if (_listeners.isEmpty) {
          _release();
          onRelease?.call();
        }
      };
      if (_hasValue) {
        listener.add(_value as T);
      }
      _ensureOpen(open, mapError);
    });
  }

  void _ensureOpen(
    Stream<T> Function() open,
    Object Function(Object error) mapError,
  ) {
    if (_source != null) {
      return;
    }
    _source = open().listen(
      add,
      onError: (Object error, StackTrace stackTrace) {
        final mapped = mapError(error);
        for (final listener in [..._listeners]) {
          listener.addError(mapped, stackTrace);
        }
        _dropSource();
      },
    );
  }

  void _dropSource() {
    final source = _source;
    _source = null;
    source?.cancel();
  }

  void _release() {
    _dropSource();
    _hasValue = false;
    _value = null;
  }
}
