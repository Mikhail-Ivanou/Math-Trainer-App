import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:math_trainer_app/core/di/app_env.dart';
import 'package:math_trainer_app/core/error/failure.dart';
import 'package:math_trainer_app/features/auth/data/auth_failure_mapper.dart';
import 'package:math_trainer_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:math_trainer_app/features/auth/domain/entities/auth_user.dart';

@LazySingleton(as: AuthRemoteDataSource, env: [AppEnv.firebase])
class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUser?> watchAuthState() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return AuthUser(id: user.uid, email: user.email);
    });
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
        return;
      }
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw const UnexpectedFailure();
      }
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const UnexpectedFailure();
      }
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled ||
          error.code == GoogleSignInExceptionCode.interrupted) {
        return;
      }
      throw const UnexpectedFailure();
    } on FirebaseAuthException catch (error) {
      throw mapFirebaseAuthCode(error.code);
    }
  }

  @override
  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } on GoogleSignInException {
        // Email sessions never start Google Sign-In.
      }
    }
    await _firebaseAuth.signOut();
  }

  Future<void> _guard(Future<UserCredential> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (error) {
      throw mapFirebaseAuthCode(error.code);
    }
  }
}
