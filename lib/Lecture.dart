import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:internet_file/internet_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'image_banner.dart';
import 'text_section.dart';
import 'circle.dart';
import 'dart:async';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';

class Lecturepage extends StatefulWidget {
  @override
  _Lecturepage createState() => _Lecturepage();
}

class _Lecturepage extends State<Lecturepage> {
  String pathPDF = "";
  String pathPDF2 = "";
  String pathPDF3 = "";
  String pathPDF4 = "";
  String pathPDF5 = "";
  String pathPDF6 = "";
  String pathPDF7 = "";
  String pathPDF8 = "";
  String pathPDF9 = "";
  String pathPDF10 = "";

  @override
  void initState() {
    super.initState();
    fromAsset("assets/Lectures/TAQDIMOT1.pdf", 'TAQDIMOT1.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/TAQDIMOT2.pdf', 'TAQDIMOT2.pdf').then((f) {
      setState(() {
        pathPDF2 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/3-TAQDIMOT.pdf', '3-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF3 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/4-TAQDIMOT.pdf', '4-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF4 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/5-TAQDIMOT.pdf', '5-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF5 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/6-TAQDIMOT.pdf', '6-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF6 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/7-TAQDIMOT.pdf', '7-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF7 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/8-TAQDIMOT.pdf', '8-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF8 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/9-TAQDIMOT.pdf', '9-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF9 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/10-TAQDIMOT.pdf', '10-TAQDIMOT.pdf').then((f) {
      setState(() {
        pathPDF10 = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma'ruza matnlari"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Parazitologiya fanining predmeti, tarkibi va vazifalari",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Tirik organizmlarning o’zaro munosabatlari va uning asosiy shakllari",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Parazit va xo’jayin orasidagi bog’lanishning turli-tuman shakllari",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF3),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Doimiy (stasionar) parazitizm",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF4),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Parazitlarning xo’jayinlari",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF5),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Parazitlarning xo’jayin tanasiga kirishi va undan chiqish yo’llari",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF6),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Parazit va xo’jayin orasidagi munosabatlar",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF7),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Xo’jayinning parazitga ta’siri. Tashqi muhit omillarining parazit va xo’jayinga ta’siri",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF8),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Parazitlarning tuzilishi va hayot siklidagi adaptasiyalar",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF9),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: const Text(
                        "Infeksion va invazion kasalliklar. Transmissiv kasalliklar",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          textBaseline: TextBaseline.ideographic,
                        ),
                      ),
                      onTap: () {
                        if (pathPDF.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(path: pathPDF10),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({Key? key, this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
    );
  }
}