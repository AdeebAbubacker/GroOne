import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static FirebaseApp? _secondaryApp;

  static Future<void> initializeSecondaryApp() async {
    _secondaryApp = await Firebase.initializeApp(
      name: 'secondaryApp',
      options: FirebaseOptions(
        apiKey: "AIzaSyBItdmf8CUHEXuuuXUZfpt3aaUn9Kz4yH8",
        appId: "1:311939151127:android:ac0c05e9e1b39f97a37352",
        messagingSenderId: "311939151127",
        projectId: "gro-fleet-c146a",
        authDomain: "gro-fleet-c146a.firebaseapp.com",
        storageBucket: "gro-fleet-c146a.appspot.com",
      )
    );
  }

  static FirebaseApp get secondaryApp => _secondaryApp!;
}
