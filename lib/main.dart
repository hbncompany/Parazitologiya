import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.light(), // Provide light theme
      darkTheme: ThemeData.dark(), // Provide dark theme
      home: MyApp(),
    ),
  );
}

class MyApphh extends StatelessWidget {
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, model, __) {
          return MaterialApp(
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                color: Colors.white54,
              )), // Provide light theme.
              darkTheme: ThemeData.dark(), // Provide dark theme.
              themeMode: model.mode, // Decides which theme to show.
              home: MainPage()
              // Scaffold(
              //   appBar: AppBar(title: Text('Light/Dark Theme')),
              //   body: ElevatedButton(
              //     onPressed: () => model.toggleMode(),
              //     child: Text('Toggle Theme'),
              //   ),
              // ),
              );
        },
      ),
    );
  }
}

class ThemeModel with ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
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
    final model = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: model.mode == ThemeMode.light
                ? Colors.blueAccent
                : Colors.white),
        elevation: 8.0,
        title: Text(
          'F I Z I O L O G I Y A',
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white,
              fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              color:
                  model.mode == ThemeMode.light ? Colors.black : Colors.white,
              onPressed: () => model.toggleMode(),
              icon: Icon(model.mode == ThemeMode.light
                  ? Icons.nights_stay_outlined
                  : Icons.wb_sunny_outlined)
              // child: Text(model.mode == ThemeMode.light ? "Tungi rejim" : "Kunduzgi rejim"),
              ),
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // iconTheme: Theme.of(context).appBarTheme.iconTheme,
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
                      // color: Theme.of(context).primaryColor,
                      ),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height *
                            containerHeightFraction *
                            0.16,
                        child: Image.asset('assets/images/Fplants.png'),
                      ),
                      Container(
                        child: Text(
                          'FIZIOLOGIYA',
                          style: TextStyle(
                            color: model.mode == ThemeMode.light
                                ? Colors.blueAccent
                                : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    model.mode == ThemeMode.light
                        ? Icons.nights_stay_outlined
                        : Icons.wb_sunny_outlined,
                  ),
                  title: Text(model.mode == ThemeMode.light
                      ? "Tungi rejim"
                      : "Kunduzgi rejim"),
                  onTap: () => model.toggleMode(),
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
                        builder: (context) => MainPages(),
                      ),
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
                      onTap: () {},
                      child: Card(
                        elevation: 8.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              containerWidthFraction *
                              1,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                // mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Image.asset(
                                        'assets/images/Mainplant.png'), // Replace with your image paths
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Flexible(
                                      child:Text("PLANT", style: TextStyle(fontSize: 32,
                                          color: model.mode == ThemeMode.light
                                              ? Colors.blueAccent
                                              : Colors.white),)
                                    ),
                                  ),
                                  Container(
                                    child: Flexible(
                                        child:Text("PHYSIOLOGY", style: TextStyle(fontSize: 32,
                                            color: model.mode == ThemeMode.light
                                                ? Colors.blueAccent
                                                : Colors.white),)
                                    ),
                                  ),
                                ],
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
                                // color: model.mode == ThemeMode.light ? Colors.white:Colors.grey,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              containerWidthFraction *
                                              0.1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              containerHeightFraction *
                                              0.1,
                                          child: Image.asset(
                                              'assets/images/Uzbekistan.jpg')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "O'zbek tilida darsliklar",
                                        style: TextStyle(
                                            color: model.mode == ThemeMode.light
                                                ? Colors.blueAccent
                                                : Colors.white,
                                            fontSize: 25),
                                        textAlign: TextAlign.center,
                                      ),
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
                              builder: (context) => MainPages_ru(),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 8.0,
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
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              containerWidthFraction *
                                              0.1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              containerHeightFraction *
                                              0.1,
                                          child: Image.asset(
                                              'assets/images/Russian.png')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Уроки на русском языке",
                                        style: TextStyle(
                                            color: model.mode == ThemeMode.light
                                                ? Colors.blueAccent
                                                : Colors.white,
                                            fontSize: 25),
                                        textAlign: TextAlign.center,
                                      ),
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
            Text(
              "Muallif: ...... .....",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: model.mode == ThemeMode.light
                      ? Colors.blueAccent
                      : Colors.white, fontSize: 20),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class MainPages extends StatelessWidget {
  final double containerWidthFraction = 0.95;
  final double containerHeightFraction = 0.95;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: model.mode == ThemeMode.light
                ? Colors.blueAccent
                : Colors.white),
        title: Text(
          "O'zbek tilida darsliklar",
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white),
        ),
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
                      openPDF(context,
                          'assets/pdf/Maruza_uz.pdf'); // Replace with your PDF paths
                    },
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                                'assets/images/Book.png'), // Replace with your image paths
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ma'ruzalar matni",
                              style: TextStyle(
                                  color: model.mode == ThemeMode.light
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  fontSize: 20),
                            ),
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
                      openPDF(context,
                          'assets/pdf/Laboratoriya.pdf'); // Replace with your PDF paths
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
                            child: Text(
                              "Laboratoriya",
                              style: TextStyle(
                                  color: model.mode == ThemeMode.light
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  fontSize: 20),
                            ),
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

class MainPages_ru extends StatelessWidget {
  final double containerWidthFraction = 0.95;
  final double containerHeightFraction = 0.95;
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: model.mode == ThemeMode.light
                ? Colors.blueAccent
                : Colors.white),
        title: Text(
          "Уроки на русском языке",
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white),
        ),
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
                      openPDF(context,
                          'assets/pdf/Maruza_ru.pdf'); // Replace with your PDF paths
                    },
                    child: Card(
                      elevation: 8.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                                'assets/images/Book.png'), // Replace with your image paths
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Лекция",
                              style: TextStyle(
                                  color: model.mode == ThemeMode.light
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  fontSize: 20),
                            ),
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
                      openPDF(context,
                          'assets/pdf/Laboratoriya_ru.pdf'); // Replace with your PDF paths
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
                            child: Text(
                              "Лаборатория",
                              style: TextStyle(
                                  color: model.mode == ThemeMode.light
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  fontSize: 20),
                            ),
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
    final model = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: model.mode == ThemeMode.light
                ? Colors.blueAccent
                : Colors.white),
        elevation: 8.0,
        title: Text("READING",
            style: TextStyle(
            color: model.mode == ThemeMode.light
            ? Colors.blueAccent
                : Colors.white),),
        actions: [
          if (_isReady)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text('${_currentPage + 1}/$_totalPages',
                  style: TextStyle(
                      color: model.mode == ThemeMode.light
                          ? Colors.blueAccent
                          : Colors.white),),
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
