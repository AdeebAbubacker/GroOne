
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KycVerificationWebView extends StatefulWidget {
  final String? url;

  const KycVerificationWebView({super.key,required this.url});

  @override
  KycVerificationWebViewState createState() => KycVerificationWebViewState();
}

class KycVerificationWebViewState extends State<KycVerificationWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isBack=false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
         onUrlChange: (change) {
           if(_isBack) {
             return;
           }

           Uri? uri=Uri.tryParse(change.url??"");
           if((uri?.path??"").isNotEmpty){
              String url=change.url??"";
              print("url ${url}");
              if(url.contains('https://gro-devadmin.letsgro.co')){
                _isBack=true;
                Navigator.pop(context,true);
              }
           }


         },
        )
      );

    _delayedLoad();
  }

  Future<void> _delayedLoad() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      print("url is ${widget.url??""}");

      await _controller.loadRequest(
        Uri.parse(widget.url??""),
      );
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
            : WebViewWidget(
             controller: _controller),
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
    title: 'KYC',
    backgroundColor: Colors.transparent,
    actions: [
      20.width,
      Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
      30.width,
    ],
  );
}