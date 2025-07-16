import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
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
      // Call Cubit here
     Navigator.pop(context, true); // return true on back
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


// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentsScreen extends StatefulWidget {
//   final String url;
//   const PaymentsScreen({super.key, required this.url});

//   @override
//   State<PaymentsScreen> createState() => _PaymentsScreenState();
// }

// class _PaymentsScreenState extends State<PaymentsScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;

//   final String successRedirectPart = "ccavenue.com/receive";

//   @override
//   void initState() {
//     super.initState();

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (request) {
//             debugPrint('🌐 Navigating: ${request.url}');
//             if (request.url.contains(successRedirectPart)) {
//               Navigator.of(context).pop();
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//           onPageFinished: (url) {
//             debugPrint('Page loaded: $url');
//             setState(() => _isLoading = false);
//             if(url == 'https://test.ccavenue.com/receive/288/M_NewTC1234/servlet/BankRespReceive'){
//               Navigator.of(context).pop();
//             }
//           },
//         ),
//       );

//     _loadInitialUrl();
//   }

//   Future<void> _loadInitialUrl() async {
//     await _controller.loadRequest(Uri.parse(widget.url));
//   }

//   Future<void> _refreshWebView() async {
//     debugPrint('🔄 Refresh triggered');
//     await _controller.reload();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Make Payment")),
//       body: Stack(
//         children: [
//           RefreshIndicator(
//             onRefresh: _refreshWebView,
//             child: ListView(
//               // To make RefreshIndicator work
//               physics: const AlwaysScrollableScrollPhysics(),
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: WebViewWidget(
//                     controller: _controller,
//                     gestureRecognizers: {
//                       Factory<VerticalDragGestureRecognizer>(
//                         () => VerticalDragGestureRecognizer(),
//                       ),
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }
// }
