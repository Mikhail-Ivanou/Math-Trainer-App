import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:math_trainer_app/core/firebase/firebase_keys.dart';

/// Options for the math-traineer Firebase project.
abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      _ => throw UnsupportedError(
        'Firebase is not configured for this platform.',
      ),
    };
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: FirebaseKeys.androidApiKey,
    appId: FirebaseKeys.androidAppId,
    messagingSenderId: FirebaseKeys.messagingSenderId,
    projectId: FirebaseKeys.projectId,
    storageBucket: FirebaseKeys.storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: FirebaseKeys.iosApiKey,
    appId: FirebaseKeys.iosAppId,
    messagingSenderId: FirebaseKeys.messagingSenderId,
    projectId: FirebaseKeys.projectId,
    storageBucket: FirebaseKeys.storageBucket,
    iosClientId: FirebaseKeys.iosClientId,
    iosBundleId: FirebaseKeys.iosBundleId,
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: FirebaseKeys.webApiKey,
    appId: FirebaseKeys.webAppId,
    messagingSenderId: FirebaseKeys.messagingSenderId,
    projectId: FirebaseKeys.projectId,
    authDomain: FirebaseKeys.authDomain,
    storageBucket: FirebaseKeys.storageBucket,
  );
}
