import 'package:flutter/material.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {

  late final WebViewController _controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://gro-devadmin.letsgro.co/terms-and-condition"),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: buildBodyWidget(context),
    );
  }


  // Body
  Widget buildBodyWidget(BuildContext context){
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Terms and Conditions",
                style: AppTextStyle.textBlackColor30w500,
              ),
            ),
            Expanded(child: WebViewWidget(controller: _controller)),
          ],
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }


  PreferredSizeWidget buildAppBarWidget(BuildContext context){
    return CommonAppBar(
      backgroundColor: Colors.transparent,
      actions: [
        translateWiget(
          onTap: () {
            Navigator.push(
              context,
              commonRoute(ChooseLanguageScreen(isCloseButton: true)),
            );
          },
        ),
        20.width,
        customerSupportWidget(
          onTap: () {
            showCustomerCareBottomSheet(context);
          },
        ),
        20.width,
        Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
        30.width,
      ],
    );
  }

}
