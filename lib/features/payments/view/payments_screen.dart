import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentsScreen extends StatefulWidget {
  final String url;
  const PaymentsScreen({super.key,required this.url});

  @override
  PaymentsScreenState createState() => PaymentsScreenState();
}

class PaymentsScreenState extends State<PaymentsScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // instantiate the controller and configure it
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: WebViewWidget(controller: _controller),
    );
  }
}

  // appbar
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      centreTile: true,
      title: 'Make payment',
      backgroundColor: Colors.transparent,
      actions: [
        20.width,
        Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
        30.width,
      ],
    );
  }