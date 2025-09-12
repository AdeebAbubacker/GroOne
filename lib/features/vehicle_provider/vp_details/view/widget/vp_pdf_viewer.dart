import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewer extends StatefulWidget {
  final String? url;
  final String? originalFileName;

  const PdfViewer({super.key, required this.url,required  this.originalFileName });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  Future<void> downloadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${widget.originalFileName}';

      await Dio().download(widget.url??"", filePath);

      setState(() {
        localPath = filePath;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error downloading PDF: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (localPath == null) {
      return const Center(child: Text("Failed to load Document"));
    }

    return SizedBox(
      height: 500,
      width: 500,
      child: PDFView(
        filePath: localPath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        backgroundColor: Colors.grey,
        onError: (error) => debugPrint("error in pdf $error"),
        onPageError: (page, error) =>
            debugPrint("error in pdf $page: ${error.toString()}"),
      ),
    );
  }
}
