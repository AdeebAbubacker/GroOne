import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentsScreen extends StatefulWidget {
  final String url;
  final String loadId;

  const PaymentsScreen({super.key, required this.url, required this.loadId});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isPaymentLoading = false;
  bool _paymentStarted = false;
  bool _transactionCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: _handlePageStart));
    _delayedLoad();
  }

  void _handlePageStart(String url) {
    debugPrint("Page started: $url");
    if (url.contains('/updateTransaction')) _paymentStarted = true;
    if (url.contains('/process-response')) {
      setState(() => _isPaymentLoading = true);
    }
    if (url.contains('/BankRespReceive')) {
      setState(() => _isPaymentLoading = false);
    }

    if (url.contains('/redirect')) {
      setState(() => _transactionCompleted = true);
      Future.delayed(const Duration(seconds: 6), () => Navigator.pop(context, true));
    }
  }

  Future<void> _delayedLoad() async {
    await Future.delayed(const Duration(seconds: 7));
    if (mounted) {
      await _controller.loadRequest(Uri.parse(widget.url));
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AppDialog(
        dismissible: true,
        child: CommonDialogView(
          hideCloseButton: true,
          showYesNoButtonButtons: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.appText.cancelPayment, style: AppTextStyle.h3),
              20.height,
              Text(context.appText.areYouSureCancelThePayment),
              20.height,
            ],
          ),
          onClickYesButton: () => Navigator.pop(context, true),
        ),
      ),
    ) ??
        false;
  }

  Future<bool> _onBackPressed() async {
    if (_paymentStarted && !_transactionCompleted) {
      return await _showExitDialog();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _onBackPressed();
        return shouldExit;
      },
      child: Scaffold(
        appBar: CommonAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldExit = await _onBackPressed();
              if (shouldExit) Navigator.pop(context, true);
            },
          ),
          centreTile: true,
          title: context.appText.makePayment,
          backgroundColor: Colors.transparent,
          actions: [
            20.width,
            Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
            30.width,
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if(_isPaymentLoading)
                  CircularProgressIndicator().center(),
              ],
            ),
      ),
    );
  }
}
