import 'package:flutter_test/flutter_test.dart';
import 'package:math_trainer_app/core/settings/hide_solved_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('restores and stores the hide-solved preference', () async {
    SharedPreferences.setMockInitialValues({'hide_solved_tasks': true});
    final preferences = await SharedPreferences.getInstance();
    final repository = HideSolvedRepositoryImpl(preferences);

    expect(repository.hideSolved, isTrue);
    await expectLater(repository.watchHideSolved(), emits(true));

    await repository.setHideSolved(false);

    expect(repository.hideSolved, isFalse);
    expect(preferences.getBool('hide_solved_tasks'), isFalse);
  });
}
