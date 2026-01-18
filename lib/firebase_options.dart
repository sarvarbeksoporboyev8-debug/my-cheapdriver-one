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
    apiKey: 'AIzaSyDQNSow1L1JpKFElhmsvqJr0uaGwCRX-3Y',
    appId: '1:757982037388:web:67e081d6e7344c035242a9',
    messagingSenderId: '757982037388',
    projectId: 'cheap-driver-app',
    authDomain: 'cheap-driver-app.firebaseapp.com',
    storageBucket: 'cheap-driver-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQNSow1L1JpKFElhmsvqJr0uaGwCRX-3Y',
    appId: '1:757982037388:android:67e081d6e7344c035242a9',
    messagingSenderId: '757982037388',
    projectId: 'cheap-driver-app',
    storageBucket: 'cheap-driver-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDavTkL24SUh_ONzBYlOBSyg9I0sc_0mfI',
    appId: '1:757982037388:ios:f968ebeff5cc352b5242a9',
    messagingSenderId: '757982037388',
    projectId: 'cheap-driver-app',
    storageBucket: 'cheap-driver-app.firebasestorage.app',
    iosBundleId: 'com.appzler.deliverzler2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDavTkL24SUh_ONzBYlOBSyg9I0sc_0mfI',
    appId: '1:757982037388:ios:f968ebeff5cc352b5242a9',
    messagingSenderId: '757982037388',
    projectId: 'cheap-driver-app',
    storageBucket: 'cheap-driver-app.firebasestorage.app',
    iosBundleId: 'com.appzler.deliverzler2',
  );
}
