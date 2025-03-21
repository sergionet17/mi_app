// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD_I4chkDLyOHzPIusjGThTegpIXJjTNJE',
    appId: '1:944409408863:web:623af73024fe4757e732ea',
    messagingSenderId: '944409408863',
    projectId: 'tucomercio-a4667',
    authDomain: 'tucomercio-a4667.firebaseapp.com',
    storageBucket: 'tucomercio-a4667.firebasestorage.app',
    measurementId: 'G-SZVP8CNQ6Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvnIxA8VOvlyi8J5mIlhy6WfyCb_LuoS0',
    appId: '1:944409408863:android:5407328fb49f98d4e732ea',
    messagingSenderId: '944409408863',
    projectId: 'tucomercio-a4667',
    storageBucket: 'tucomercio-a4667.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1fDFTMUTuoNojCTrjqnQI6OJ4qcU8LpY',
    appId: '1:944409408863:ios:44b674114dea1e05e732ea',
    messagingSenderId: '944409408863',
    projectId: 'tucomercio-a4667',
    storageBucket: 'tucomercio-a4667.firebasestorage.app',
    iosBundleId: 'com.example.miApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1fDFTMUTuoNojCTrjqnQI6OJ4qcU8LpY',
    appId: '1:944409408863:ios:44b674114dea1e05e732ea',
    messagingSenderId: '944409408863',
    projectId: 'tucomercio-a4667',
    storageBucket: 'tucomercio-a4667.firebasestorage.app',
    iosBundleId: 'com.example.miApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD_I4chkDLyOHzPIusjGThTegpIXJjTNJE',
    appId: '1:944409408863:web:e9a13c7896e022dde732ea',
    messagingSenderId: '944409408863',
    projectId: 'tucomercio-a4667',
    authDomain: 'tucomercio-a4667.firebaseapp.com',
    storageBucket: 'tucomercio-a4667.firebasestorage.app',
    measurementId: 'G-8LX2KLNZEN',
  );
}
