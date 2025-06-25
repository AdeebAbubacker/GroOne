import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';

class FastTagScreen extends StatelessWidget {
  const FastTagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Fast Tag"),
      body: SafeArea(
          child: Center(child: Text("Coming Soon"))),
    );
  }
}
