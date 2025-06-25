import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

class GpsScreen extends StatelessWidget {
  const GpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "GPS".capitalize),
      body: SafeArea(
          child: Center(child: Text("Coming Soon"))),
    );
  }
}
