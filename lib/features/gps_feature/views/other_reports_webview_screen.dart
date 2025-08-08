// lib/features/gps_feature/views/other_reports_webview_screen.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';

class OtherReportsWebViewScreen extends StatelessWidget {
  const OtherReportsWebViewScreen({super.key});

  Future<String> _buildAuthenticatedUrl() async {
    try {
      /// Note : need to pass the dynamic data here (need to change here username to mobile number)
      ///
      final username = 'rishika';
      final password = 'Roadcast@123';

      if (username.isEmpty || password.isEmpty) {
        throw Exception(
          'Authentication credentials not found. Please login again.',
        );
      }

      // Create credentials string exactly like Android
      String credentials = '$username:$password';

      // Encode to Base64 exactly like Android
      final List<int> bytes = utf8.encode(credentials);
      final String basic = base64Encode(bytes);

      // Build URL exactly like Android - you may need to adjust the BASE_URL
      const String baseUrl = 'https://track.letsgro.co/';
      final String url = '${baseUrl}v1/auth/login?url=/app/report&basic=$basic';

      return url;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Other Reports',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder<String>(
        future: _buildAuthenticatedUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (snapshot.hasData) {
            return _buildWebView(snapshot.data!);
          }

          return _buildErrorState('Unknown error occurred');
        },
      ),
    );
  }

  Widget _buildWebView(String url) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                // Page started loading
              },
              onPageFinished: (String url) {
                // Page finished loading
              },
              onWebResourceError: (WebResourceError error) {
                // Handle error
              },
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(url));

    return WebViewWidget(controller: controller);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryColor),
          const SizedBox(height: 16),
          Text(
            'Loading reports...',
            style: TextStyle(color: AppColors.grayColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.appRedColor),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
