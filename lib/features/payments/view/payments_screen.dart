import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/payments/cubit/payment_cubit.dart';
import 'package:gro_one_app/features/payments/cubit/payment_state.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentsScreen extends StatelessWidget {
  final String url;
  final String loadId;

  const PaymentsScreen({super.key, required this.url, required this.loadId});

  @override
  Widget build(BuildContext context) {
    return PaymentsScreenView(url: url, loadId: loadId);
  }
}

class PaymentsScreenView extends StatefulWidget {
  final String url;
  final String loadId;

  const PaymentsScreenView({super.key, required this.url, required this.loadId});

  @override
  State<PaymentsScreenView> createState() => _PaymentsScreenViewState();
}

class _PaymentsScreenViewState extends State<PaymentsScreenView> {
  late final WebViewController _controller;
  final paymentCubit = locator<PaymentCubit>();
  Timer? _redirectTimer;
  bool _hasPopped = false;

  void _safePop() {
    if (!_hasPopped && mounted) {
      _hasPopped = true;
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _redirectTimer?.cancel(); // ✅ cancel to avoid firing after dispose
    super.dispose();
  }

  // Map<String, String> upiAppPlayStoreLinks = {
  //   "phonepe": "https://play.google.com/store/apps/details?id=com.phonepe.app",
  //   "tez": "https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user", // GPay (Tez)
  //   "gpay": "https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user",
  //   "paytm": "https://play.google.com/store/apps/details?id=net.one97.paytm",
  //   "bhim": "https://play.google.com/store/apps/details?id=in.org.npci.upiapp",
  //   "cred": "https://play.google.com/store/apps/details?id=com.dreamplug.androidapp",
  //
  // };

  // String _normalizeUpiUrl(String url) {
  //   print('url is are $url');
  //   // Only normalize BHIM and Cred
  //   if (url.startsWith("bhim:") || url.startsWith("credpay:")) {
  //     print('url $url');
  //     final uri = Uri.parse(url);
  //     return Uri(
  //       scheme: "upi",
  //       host: uri.host,
  //       path: uri.path,
  //       query: uri.query,
  //     ).toString();
  //   }
  //
  //   // Keep original for GPay, PhonePe, Paytm, etc.
  //   return url;
  // }



  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: _handlePageStart,
          onNavigationRequest: (NavigationRequest request) async {
            var url = request.url;
            debugPrint("Intercepted URL: $url");

            if (url.startsWith("upi:") ||
                url.startsWith("phonepe:") ||
                url.startsWith("tez:") ||
                url.startsWith("gpay:") ||
                url.startsWith("paytmmp:") ||
                url.startsWith("bhim:") ||
                url.startsWith("credpay:")) {

              final uri = Uri.parse(url);

              // final normalizedUrl = _normalizeUpiUrl(url);
              // final uri = Uri.parse(normalizedUrl);

              print('uri is $uri');

              try {
                // Try opening the UPI app directly
                final launched = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );

                print('launched $launched');

                if (!launched) {
                  // If launch fails → go to Play Store
                  await _openPlayStore(url);
                }
              } catch (e) {
                debugPrint("Launch failed: $e");
                await _openPlayStore(url);
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          }


      ));

    paymentCubit.reset(); // optional: clear any old state
    _delayedLoad();
  }

  Future<void> _openPlayStore(String url) async {
    String? storeUrl;
    if (url.startsWith("phonepe:")) {
      storeUrl = "https://play.google.com/store/apps/details?id=com.phonepe.app";
    } else if (url.startsWith("tez:") || url.startsWith("gpay:")) {
      storeUrl = "https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user";
    } else if (url.startsWith("paytmmp:")) {
      storeUrl = "https://play.google.com/store/apps/details?id=net.one97.paytm";
    } else if (url.startsWith("upi:")) {   // BHIM fallback
      storeUrl = "https://play.google.com/store/apps/details?id=in.org.npci.upiapp";
    } else if (url.startsWith("bhim:")) {
      storeUrl = "https://play.google.com/store/apps/details?id=in.org.npci.upiapp";
    } else if (url.startsWith("credpay:")) {
      storeUrl = "https://play.google.com/store/apps/details?id=com.dreamplug.androidapp";
    }

    if (storeUrl != null) {
      await launchUrl(Uri.parse(storeUrl), mode: LaunchMode.externalApplication);
    }
  }

  void _handlePageStart(String url) {
    print('url is $url');
    if (url.contains('/updateTransaction')) paymentCubit.setPaymentStarted(true);
    if (url.contains('/process-response')) paymentCubit.setPaymentLoading(true);
    if (url.contains('/BankRespReceive')) paymentCubit.setPaymentLoading(false);
    if (url.contains('/redirect')) {
      paymentCubit.setTransactionCompleted(true);
      _redirectTimer = Timer(const Duration(seconds: 4), () {
        _safePop(); // 👈 USE SAFE POP
      });
    }
  }

  Future<void> _delayedLoad() async {
    await Future.delayed(const Duration(seconds: 7));
    if (mounted) {
      await _controller.loadRequest(Uri.parse(widget.url));
      paymentCubit.setLoading(false);
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

  Future<bool> _onBackPressed(PaymentState state) async {
    if (state.paymentStarted && !state.transactionCompleted) {
      return await _showExitDialog();
    }
    _safePop(); // 👈 USE SAFE POP
    return false; // prevent extra pops
  }

  @override
  Widget build(BuildContext context) {
    print('loading');
    return BlocBuilder<PaymentCubit, PaymentState>(
      // value: paymentCubit,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => await _onBackPressed(state),
          child: SafeArea(
            top: false,
            child: Scaffold(
              appBar: CommonAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    final shouldExit = await _onBackPressed(state);
                    if (shouldExit) Navigator.pop(context, true);
                  },
                ),
                centreTile: true,
                title: context.appText.makePayment,
                backgroundColor: Colors.transparent,
                actions: [
                  Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
                ],
              ),
              body: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (state.isPaymentLoading)
                    const CircularProgressIndicator().center(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}