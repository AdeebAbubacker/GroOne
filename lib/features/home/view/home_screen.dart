import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => addPostFrameCallback(() {
    //  Call your init methods
  });

  void disposeFunction() => addPostFrameCallback(() {

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.appName),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(children: [Text("Demo", style: AppTextStyle.h1.copyWith(fontSize: height*0.5))]),
    );
  }
}
