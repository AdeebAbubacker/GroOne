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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: _handlePageStart));

    paymentCubit.reset(); // optional: clear any old state
    _delayedLoad();
  }

  void _handlePageStart(String url) {
    if (url.contains('/updateTransaction')) paymentCubit.setPaymentStarted(true);
    if (url.contains('/process-response')) paymentCubit.setPaymentLoading(true);
    if (url.contains('/BankRespReceive')) paymentCubit.setPaymentLoading(false);
    if (url.contains('/redirect')) {
      paymentCubit.setTransactionCompleted(true);
      Future.delayed(const Duration(seconds: 6), () => Navigator.pop(context, true));
    }
  }

  Future<void> _delayedLoad() async {
    await Future.delayed(const Duration(seconds: 12));
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
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      // value: paymentCubit,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => await _onBackPressed(state),
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
                20.width,
                Image.asset(AppImage.png.appIcon, width: 74.25, height: 33),
                30.width,
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
        );
      },
    );
  }
}