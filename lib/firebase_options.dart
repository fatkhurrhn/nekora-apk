import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnimplementedError('iOS not supported yet');
      case TargetPlatform.macOS:
        throw UnimplementedError('macOS not supported yet');
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBjkUnxRBw4UVfKDGwE1v516PSQGOwD7_0',
    appId: '1:967248394103:web:belum_ada_isi_web',
    messagingSenderId: '967248394103',
    projectId: 'nekora-65130',
    authDomain: 'nekora-65130.firebaseapp.com',
    storageBucket: 'nekora-65130.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjkUnxRBw4UVfKDGwE1v516PSQGOwD7_0',
    appId: '1:967248394103:android:adf50e06e269535200d372',
    messagingSenderId: '967248394103',
    projectId: 'nekora-65130',
    storageBucket: 'nekora-65130.firebasestorage.app',
  );
}
