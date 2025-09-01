import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static FirebaseApp? _secondaryApp;

  static Future<void> initializeSecondaryApp() async {
    _secondaryApp = await Firebase.initializeApp(
      name: 'secondaryApp',
      options: FirebaseOptions(
        apiKey: "AIzaSyBItdmf8CUHEXuuuXUZfpt3aaUn9Kz4yH8",
        appId:
            Platform.isIOS
                ? "1:311939151127:ios:9e7ceb52007f442da37352" // Use the correct iOS app ID
                : "1:311939151127:android:65af003fa57613e7a37352",
        messagingSenderId: "311939151127",
        projectId: "gro-fleet-c146a",
        authDomain: "gro-fleet-c146a.firebaseapp.com",
        storageBucket: "gro-fleet-c146a.appspot.com",
        iosBundleId: "com.gro.oneapp", // Match your main bundle ID
      ),
    );
  }

  static FirebaseApp get secondaryApp => _secondaryApp!;
}
