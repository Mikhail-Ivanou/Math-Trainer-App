import 'package:firebase_core/firebase_core.dart';

/// Placeholder until `flutterfire configure` replaces this file.
/// Flip [isConfigured] only together with real platform options.
abstract final class DefaultFirebaseOptions {
  static const bool isConfigured = false;

  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase options are not configured. Run flutterfire configure.',
    );
  }
}
