import 'dart:async';

import 'package:math_trainer_app/core/dependencies.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository.dart';

class HideSolvedCubit extends Cubit<bool> {
  HideSolvedCubit(this._repository) : super(_repository.hideSolved) {
    _subscription = _repository.watchHideSolved().listen(emit);
  }

  final HideSolvedRepository _repository;
  late final StreamSubscription<bool> _subscription;

  Future<void> setHideSolved(bool value) => _repository.setHideSolved(value);

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
