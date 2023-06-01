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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCT6JfZyeMY6Cbs-aY6S19spL3pM5_W9mg',
    appId: '1:763890485189:web:689b4e1875e414cb1eedac',
    messagingSenderId: '763890485189',
    projectId: 'shifaa-d8001',
    authDomain: 'shifaa-d8001.firebaseapp.com',
    storageBucket: 'shifaa-d8001.appspot.com',
    measurementId: 'G-D23W3XQRSC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBRx8Ayk6GnxY7vtdfUW6Lzv85VrLQSqVw',
    appId: '1:763890485189:android:ae95def0a0476e561eedac',
    messagingSenderId: '763890485189',
    projectId: 'shifaa-d8001',
    storageBucket: 'shifaa-d8001.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZ4HcJHF2ZpbVC6BWm85l1M3_8mY79G2k',
    appId: '1:763890485189:ios:40c99c9c4772ed591eedac',
    messagingSenderId: '763890485189',
    projectId: 'shifaa-d8001',
    storageBucket: 'shifaa-d8001.appspot.com',
    iosClientId: '763890485189-4rpeim8emd6vnhmqrpa7p8krlpljjqsf.apps.googleusercontent.com',
    iosBundleId: 'com.shifaa.shifaa',
  );
}