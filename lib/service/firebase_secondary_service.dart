import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static FirebaseApp? _secondaryApp;

  // static Future<void> initializeSecondaryApp() async {
  //   _secondaryApp = await Firebase.initializeApp(
  //     name: 'secondaryApp',
  //     options: FirebaseOptions(
  //       apiKey: "AIzaSyBItdmf8CUHEXuuuXUZfpt3aaUn9Kz4yH8",
  //       appId: "1:311939151127:android:ac0c05e9e1b39f97a37352",
  //       messagingSenderId: "311939151127",
  //       projectId: "gro-fleet-c146a",
  //       authDomain: "gro-fleet-c146a.firebaseapp.com",
  //       storageBucket: "gro-fleet-c146a.appspot.com",
  //     )
  //   );
  // }
  static Future<void> initializeSecondaryApp() async {
    _secondaryApp = await Firebase.initializeApp(
      name: 'secondaryApp',
      options: FirebaseOptions(
        apiKey: "AIzaSyBItdmf8CUHEXuuuXUZfpt3aaUn9Kz4yH8",
        appId: Platform.isIOS
            ? "1:311939151127:ios:5f7ec4f0f861d3be3a5a38"
            : "1:311939151127:android:ac0c05e9e1b39f97a37352",
        messagingSenderId: "311939151127",
        projectId: "gro-fleet-c146a",
        authDomain: "gro-fleet-c146a.firebaseapp.com",
        storageBucket: "gro-fleet-c146a.appspot.com",
        iosBundleId: "com.gro.onefleet", // <- From your .plist
        iosClientId:
        "311939151127-jomldd5rhvle1if8ls6mhh97fdjj87fb.apps.googleusercontent.com", // <- From your .plist
      ),
    );
  }

  static FirebaseApp get secondaryApp => _secondaryApp!;
}
