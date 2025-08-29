
import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
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
  final securePrefs = locator<SecuredSharedPreferences>();
  bool _isLoading = true;
  bool _isBack=false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
         onUrlChange: (change) async{
           if(_isBack) {
             return;
           }

           Uri? uri=Uri.tryParse(change.url??"");
           if((uri?.path??"").isNotEmpty){
              String url=change.url??"";
              if(url.contains('https://gro-devadmin.letsgro.co')){
                _isBack=true;
                 await securePrefs.saveBoolean(AppString.sessionKey.iskycAdarWebview,true);
                if(mounted) {
                  Navigator.pop(context,true);
                }
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
    return  SafeArea(
      child: WillPopScope(
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
    showInUpperCase: true,
    title: context.appText.aadhaarVerification,
    backgroundColor: Colors.transparent,
    actions: [
      20.width,
      Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
      30.width,
    ],
  );
}