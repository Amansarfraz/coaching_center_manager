// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'Android Firebase configuration is not available yet.',
        );

      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS Firebase configuration is not available yet.',
        );

      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS Firebase configuration is not available yet.',
        );

      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows Firebase configuration is not available yet.',
        );

      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux Firebase configuration is not available yet.',
        );

      default:
        throw UnsupportedError('This platform is not supported.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBOmu7mloa0N2M1mwgkJIDCNwKVma0drKI',
    appId: '1:535310271261:web:964de80e58085afe8317f4',
    messagingSenderId: '535310271261',
    projectId: 'coaching-center-manager-a6a40',
    authDomain: 'coaching-center-manager-a6a40.firebaseapp.com',
    storageBucket: 'coaching-center-manager-a6a40.firebasestorage.app',
    measurementId: 'G-WW6LC2WD48',
  );
}
