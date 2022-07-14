// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGd6cJrsCfJVXl1ezMwnPVEN1azmR4HPI',
    appId: '1:775372638151:android:5bd79472afd9238a1d7be2',
    messagingSenderId: '775372638151',
    projectId: 'animequest-94c00',
    databaseURL: 'https://animequest-94c00-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'animequest-94c00.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDP4wt26zFNG3__4jDMp-COxoW3BpeKuM',
    appId: '1:775372638151:ios:be0cbe7ed77bae961d7be2',
    messagingSenderId: '775372638151',
    projectId: 'animequest-94c00',
    databaseURL: 'https://animequest-94c00-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'animequest-94c00.appspot.com',
    iosClientId: '775372638151-ji2cr1jc18u73qbfnind6muhml8p87p0.apps.googleusercontent.com',
    iosBundleId: 'com.anime.quest.aquest',
  );
}
