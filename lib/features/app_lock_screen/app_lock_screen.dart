import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AppLockScreen extends StatefulWidget {
  final Widget child;

  const AppLockScreen({super.key, required this.child});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _authenticate() async {
    try {
      final isAvailable = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!isAvailable) return;

      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to unlock the app',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      setState(() => _isAuthenticated = didAuthenticate);
    } catch (e) {
      debugPrint('Authentication error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      // _isAuthenticated
      //   ?
      widget.child;
    //     : const Scaffold(
    //   body: Center(child: Text("Locked")),
    // );
  }
}
