import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white54,
          )),
      home: MainPage(),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double containerWidthFraction = 0.95;
    final double containerHeightFraction = 0.95;
    return Scaffold(
      appBar: AppBar(
        elevation: 8.0,
        title: const Text('F I Z I O L O G I Y A',
          style: TextStyle(color: Colors.blue, fontSize: 25),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPages(),),
              );
            },
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.2,
                image: AssetImage(
                    'assets/images/back.jpg'), // Replace with your image asset path
                fit: BoxFit.fill,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Drawer Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPages(),),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.verified_user,
                  ),
                  title: const Text('Profil'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondaryPage(index: 0)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                  ),
                  title: const Text("O'qituvchi"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPages(),),
                    );
                  },
                ),
                const AboutListTile(
                  icon: Icon(
                    Icons.info,
                  ),
                  applicationIcon: Icon(
                    Icons.person_2_outlined,
                  ),
                  applicationName: 'Fiziologiya',
                  applicationVersion: '1.0.1',
                  applicationLegalese: '©hbn_company',
                  child: Text('About app'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  containerHeightFraction *
                  5,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 3.0)),
                  Flexible(
                    fit: FlexFit.loose,
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Card(
                        elevation: 8.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              containerWidthFraction *
                              1,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Image.asset(
                                    'assets/images/Plants.png'), // Replace with your image paths
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPages(),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 8.0,
                          color: Colors.white38,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    containerWidthFraction *
                                    1,
                                height: MediaQuery.of(context).size.height *
                                    containerHeightFraction *
                                    0.1,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: MediaQuery.of(context).size.width *
                                              containerWidthFraction *
                                              0.1,
                                          height: MediaQuery.of(context).size.height *
                                              containerHeightFraction *
                                              0.1,
                                          child: Image.asset('assets/images/Uzbekistan.jpg')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("O'zbek tilida darsliklar",
                                        style: TextStyle(color: Colors.blueAccent, fontSize: 25),
                                        textAlign: TextAlign.center,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Flexible(
                      fit: FlexFit.loose,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPages(),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 8.0,
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    containerWidthFraction *
                                    1,
                                height: MediaQuery.of(context).size.height *
                                    containerHeightFraction *
                                    0.1,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: MediaQuery.of(context).size.width *
                                              containerWidthFraction *
                                              0.1,
                                          height: MediaQuery.of(context).size.height *
                                              containerHeightFraction *
                                              0.1,
                                          child: Image.asset('assets/images/Russian.png')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Уроки на русском языке",
                                        style: TextStyle(color: Colors.blueAccent, fontSize: 25),
                                        textAlign: TextAlign.center,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.person_3_rounded), onPressed: () {}),
            Text("Muallif: Falonchiyev Fistonchi",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueAccent, fontSize: 20),),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class MainPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAIN PAGES'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondaryPage(index: 1),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                                'assets/images/Lab.png'), // Replace with your image paths
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Lab 1'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondaryPage(index: 2),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                                'assets/images/Lab.png'), // Replace with your image paths
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Lab 2'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondaryPage(index: 3),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                                'assets/images/Lab.png'), // Replace with your image paths
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Lab 3'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondaryPage(index: 4),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                                'assets/images/Lab.png'), // Replace with your image paths
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Lab 4'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryPage extends StatelessWidget {
  final int index;

  SecondaryPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secondary Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                openPDF(context,
                    'assets/1-LABORATORIYA.pdf'); // Replace with your PDF paths
              },
              child: Text('Read PDF 1'),
            ),
            ElevatedButton(
              onPressed: () {
                openPDF(context,
                    'assets/pdf/1-LABORATORIYA.pdf'); // Replace with your PDF paths
              },
              child: Text('Open PDF 2'),
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

class PDFViewPage extends StatefulWidget {
  final String path;

  PDFViewPage({required this.path});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  late PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        actions: [
          if (_isReady)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text('${_currentPage + 1}/$_totalPages'),
              ),
            ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.shareFiles([widget.path], text: 'Check out this PDF');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: false,
            onRender: (_pages) {
              setState(() {
                _totalPages = _pages!;
                _isReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page ?? 0;
                _totalPages = total ?? 0;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
          ),
          if (!_isReady)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
