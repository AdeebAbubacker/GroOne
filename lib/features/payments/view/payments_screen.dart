import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentsScreen extends StatefulWidget {
  final String url;
  final String loadId;
  const PaymentsScreen({super.key,required this.url,required this.loadId});

  @override
  PaymentsScreenState createState() => PaymentsScreenState();
}

class PaymentsScreenState extends State<PaymentsScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white);

    _delayedLoad();
  }

  Future<void> _delayedLoad() async {
    await Future.delayed(const Duration(seconds: 7));
    if (mounted) {
      await _controller.loadRequest(Uri.parse(widget.url));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
    onWillPop: () async {
     Navigator.pop(context, true);
  return false;
    },
    child: Scaffold(
        appBar: buildAppBarWidget(context),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: _controller),
      ),
    );
  }
}


  // appbar
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      leading: IconButton(onPressed: () {
         Navigator.pop(context, true); 
      }, icon: Icon(Icons.arrow_back)),
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
