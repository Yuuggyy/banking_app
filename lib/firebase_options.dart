// File generated manually based on Firebase project config
// Project: myrawapp-c7f73

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
    apiKey: 'AIzaSyD5SWGdH-6uqGbb_MHYzIiFnRmuDzq1aok',
    appId: '1:490551695666:web:5f9c63fd06227f8199df2b',
    messagingSenderId: '490551695666',
    projectId: 'myrawapp-c7f73',
    authDomain: 'myrawapp-c7f73.firebaseapp.com',
    storageBucket: 'myrawapp-c7f73.firebasestorage.app',
    measurementId: 'G-C1TYB1HD2Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5SWGdH-6uqGbb_MHYzIiFnRmuDzq1aok',
    appId: '1:490551695666:android:placeholder',
    messagingSenderId: '490551695666',
    projectId: 'myrawapp-c7f73',
    authDomain: 'myrawapp-c7f73.firebaseapp.com',
    storageBucket: 'myrawapp-c7f73.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5SWGdH-6uqGbb_MHYzIiFnRmuDzq1aok',
    appId: '1:490551695666:ios:placeholder',
    messagingSenderId: '490551695666',
    projectId: 'myrawapp-c7f73',
    authDomain: 'myrawapp-c7f73.firebaseapp.com',
    storageBucket: 'myrawapp-c7f73.firebasestorage.app',
    iosBundleId: 'com.example.bankingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5SWGdH-6uqGbb_MHYzIiFnRmuDzq1aok',
    appId: '1:490551695666:ios:placeholder',
    messagingSenderId: '490551695666',
    projectId: 'myrawapp-c7f73',
    authDomain: 'myrawapp-c7f73.firebaseapp.com',
    storageBucket: 'myrawapp-c7f73.firebasestorage.app',
    iosBundleId: 'com.example.bankingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD5SWGdH-6uqGbb_MHYzIiFnRmuDzq1aok',
    appId: '1:490551695666:web:5f9c63fd06227f8199df2b',
    messagingSenderId: '490551695666',
    projectId: 'myrawapp-c7f73',
    authDomain: 'myrawapp-c7f73.firebaseapp.com',
    storageBucket: 'myrawapp-c7f73.firebasestorage.app',
    measurementId: 'G-C1TYB1HD2Q',
  );
}
