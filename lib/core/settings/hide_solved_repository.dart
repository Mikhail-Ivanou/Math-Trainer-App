abstract interface class HideSolvedRepository {
  bool get hideSolved;

  Stream<bool> watchHideSolved();

  Future<void> setHideSolved(bool value);
}
