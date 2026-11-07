import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: HideSolvedRepository)
class HideSolvedRepositoryImpl implements HideSolvedRepository {
  HideSolvedRepositoryImpl(this._preferences)
    : _values = BehaviorSubject<bool>.seeded(
        _preferences.getBool(_storageKey) ?? false,
      );

  static const _storageKey = 'hide_solved_tasks';

  final SharedPreferences _preferences;
  final BehaviorSubject<bool> _values;

  @override
  bool get hideSolved => _values.value;

  @override
  Stream<bool> watchHideSolved() => _values.stream;

  @override
  Future<void> setHideSolved(bool value) async {
    _values.add(value);
    await _preferences.setBool(_storageKey, value);
  }
}
