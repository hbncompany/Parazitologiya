import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class LectureCard extends StatelessWidget {
  final String pdfPath; // Path to the PDF file
  final String title;   // Title of the lecture

  const LectureCard({
    Key? key,
    required this.pdfPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openPDF(context, pdfPath); // Call your PDF opening method here
      },
      child: Card(
        elevation: 8.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1, // Adjust width
              height: MediaQuery.of(context).size.height * 0.1, // Adjust height
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Image.asset('assets/images/Book.png'), // Replace with your image path
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          color:  Provider.of<ThemeModel>(context).mode == ThemeMode.light
                              ? Colors.white
                              : Colors.blue,
                          fontSize: 15,
                          textBaseline: TextBaseline.ideographic,
                        ),
                        maxLines: 3, // Limit text to 3 lines
                        overflow: TextOverflow.ellipsis, // Truncate overflowing text
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openPDF(BuildContext context, String assetPath) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${assetPath.split('/').last}");
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewPage(path: file.path),
      ),
    );
  }
}

class PPTCard extends StatelessWidget {
  final String pdfPath; // Path to the PDF file
  final String title;   // Title of the lecture

  const PPTCard({
    Key? key,
    required this.pdfPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openPDF(context, pdfPath); // Call your PDF opening method here
      },
      child: Card(
        elevation: 8.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1, // Adjust width
              height: MediaQuery.of(context).size.height * 0.1, // Adjust height
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Image.asset('assets/images/presentations.jpg'), // Replace with your image path
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title.isNotEmpty
                              ? title[0].toUpperCase() + title.substring(1).toLowerCase()
                              : title,  // Ensure the title isn't empty
                          style: TextStyle(
                            color: Provider.of<ThemeModel>(context).mode == ThemeMode.light
                                ? Colors.white
                                : Colors.blue,
                            fontSize: 15,
                            textBaseline: TextBaseline.ideographic,
                          ),
                          maxLines: 3, // Limit text to 3 lines
                          overflow: TextOverflow.ellipsis, // Truncate overflowing text
                          textAlign: TextAlign.start,
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openPDF(BuildContext context, String assetPath) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${assetPath.split('/').last}");
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewPage(path: file.path),
      ),
    );
  }
}