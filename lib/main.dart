// import 'dart:js';

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
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
import 'dart:async';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Initialize SharedPreferences
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: const MyApp(),
    ),
  );
}

class AuthProvider with ChangeNotifier {
  String _username = "";
  String _email = "";
  bool _isLoggedIn = false;

  String get username => _username;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String username) async {
    // Perform your login logic here

    // If login is successful, set the username and login status
    _username = username;
    _email = email;
    _isLoggedIn = true;

    // Store the user login details in shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('email', email);
    prefs.setBool('isLoggedIn', true);

    notifyListeners();
  }

  void setLoggedInEmail(String email) {
    _email = email;
    notifyListeners();
  }

  Future<void> logout() async {
    // Perform your logout logic here

    // Clear user login details from shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('isLoggedIn');

    // Reset the username and login status
    _username = "";
    _isLoggedIn = false;

    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedEmail = prefs.getString('email');
    final storedIsLoggedIn = prefs.getBool('isLoggedIn');

    if (storedUsername != null &&
        storedIsLoggedIn != null &&
        storedIsLoggedIn) {
      _username = storedUsername;
      _isLoggedIn = true;
    } else {
      _username = "";
      _isLoggedIn = false;
    }

    if (storedEmail != null && storedIsLoggedIn != null && storedIsLoggedIn) {
      _email = storedEmail;
      _isLoggedIn = true;
    } else {
      _email = "";
      _isLoggedIn = false;
    }

    notifyListeners();
  }
}

// class AuthProvider with ChangeNotifier {
//   String _username = "";
//   String _email = "";

//   String get username => _username;
//   String get email => _email;

//   void setLoggedInUsername(String username) {
//     _username = username;
//     notifyListeners();
//   }

//   void setLoggedInEmail(String email) {
//     _email = email;
//     notifyListeners();
//   }
// }

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  // Define other light theme properties
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  // Define other dark theme properties
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme, // Set the initial theme to light
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // You can show a loading indicator here.
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              // User is logged in, navigate to the main screen.
              return const MyHomePage();
            } else {
              // User is not logged in, navigate to the login screen.
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Check if the user is logged in by looking for a saved token or session key.
  return prefs.containsKey('userToken');
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final authProvider = Provider.of<AuthProvider>(context);
//     return const MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

class MyHomePage extends StatelessWidget {
  final double containerWidthFraction = 0.45;
  final double containerHeightFraction = 0.15;

  const MyHomePage({super.key});

  Widget _buildContainerWithButton(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * containerHeightFraction,
      width: MediaQuery.of(context).size.width * containerWidthFraction,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 194, 242, 0),
      ),
      child: const ButtonBar(
        children: [
          Text('data'),
          Icon(Icons.person),
        ],
      ),
    );
  }

  Widget _buildContainerWithButton1(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * containerHeightFraction * 0.8,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 73, 73, 72),
      ),
      child: const Column(
        children: [
          SizedBox(
            height: 50,
            width: 80,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('P a r a z i t o l o g i y a'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profilepage()),
              );
            },
          ),
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  authProvider.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  authProvider.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: const Image(
                    image: NetworkImage(
                        'https://hbnnarzullayev.pythonanywhere.com/static/logo-no-background.png')),
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
                        builder: (context) => const Profilepage()),
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
                        builder: (context) => const SecondScreen()),
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
                applicationName: 'Pararitologiya',
                applicationVersion: '1.0.25',
                applicationLegalese: '©hbn_company',
                aboutBoxChildren: [
                  Image(
                      image: NetworkImage(
                          'https://hbnnarzullayev.pythonanywhere.com/static/logo-no-background.png'))
                ],
                child: Text('About app'),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                height: MediaQuery.of(context).size.height *
                    containerHeightFraction *
                    1.2,
                width:
                    MediaQuery.of(context).size.width * containerWidthFraction,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/Lecture.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.8,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Lectures()),
                    );
                  },
                  child: TextSectiontwo('Maruzalar', ''),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(3, 5, 0, 0),
                height: MediaQuery.of(context).size.height *
                    containerHeightFraction *
                    1.2,
                width:
                    MediaQuery.of(context).size.width * containerWidthFraction,
                decoration: BoxDecoration(
                  color: Color(0x69027ee5),
                  // border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo-no-background.png'),
                      fit: BoxFit.fill),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Presents()),
                    );
                  },
                  child: TextSectiontwo('Taqdimot', ''),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 25.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(3, 5, 0, 0),
                height: MediaQuery.of(context).size.height *
                    containerHeightFraction *
                    1.2,
                width:
                    MediaQuery.of(context).size.width * containerWidthFraction,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/unnamed.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.8,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Laboratory()),
                    );
                  },
                  child: Column(
                    children: [
                      TextSectiontwo('Laboratoriya', ''),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(3, 5, 0, 0),
                height: MediaQuery.of(context).size.height *
                    containerHeightFraction *
                    1.2,
                width:
                    MediaQuery.of(context).size.width * containerWidthFraction,
                decoration: BoxDecoration(
                  color: Color(0x69027ee5),
                  // border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo-no-background.png'),
                      fit: BoxFit.fill),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Glossariy()),
                    );
                  },
                  child: TextSectiontwo('Glossariy', ''),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 25.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(3, 5, 0, 0),
                height: MediaQuery.of(context).size.height *
                    containerHeightFraction *
                    1.2,
                width:
                    MediaQuery.of(context).size.width * containerWidthFraction,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/unnamed.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.8,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoPlayersScreen()),
                    );
                  },
                  child: TextSectiontwo('Video darsliklar', ''),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(3, 5, 0, 0),
                height: MediaQuery.of(context).size.height *
                    containerHeightFraction *
                    1.2,
                width:
                    MediaQuery.of(context).size.width * containerWidthFraction,
                decoration: BoxDecoration(
                  color: Color(0x69027ee5),
                  // border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo-no-background.png'),
                      fit: BoxFit.fill),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Quiz(
                                initialIndex: 0,
                                initialScore: 0,
                              )),
                    );
                  },
                  child: TextSectiontwo('Test savollari', ''),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "O'qituvchi",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Scaffold(
        body: ListView(
          children: [
            Image.asset(
              'assets/images/Mualliflar.jpg',
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }
}

class Glossariy extends StatelessWidget {
  const Glossariy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Glossariy",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Scaffold(
        body: ListView(
          children: [
            Image.asset(
              'assets/images/Glossariy.jpg',
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
      ),
      body: const Center(
        child: Text('This is the Third Screen'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash_rounded),
            label: 'Mashina 1',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.ballot),
            icon: Icon(Icons.car_crash_rounded),
            label: 'Mashina 2',
          ),
        ],
      ),
    );
  }
}

class Succes extends StatelessWidget {
  const Succes({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Succesfully logged in!'),
      ),
      body: Center(
        child: Text(authProvider.username),
      ),
    );
  }
}

class Fail extends StatelessWidget {
  const Fail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fail'),
      ),
      body: const Center(
        child: Text('Login Failed!'),
      ),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  PdfViewerPage({required this.pdfUrl});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late String downloadedFilePath = '';

  @override
  void initState() {
    super.initState();
    checkIfFileExists();
  }

  Future<void> checkIfFileExists() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final fileName = _getFileNameFromUrl(widget.pdfUrl);
    final localFilePath = "${documentDirectory.path}/$fileName";

    if (await File(localFilePath).exists()) {
      setState(() {
        downloadedFilePath = localFilePath;
      });
    } else {
      downloadFile(fileName);
    }
  }

  Future<void> downloadFile(String fileName) async {
    final response = await http.get(Uri.parse(widget.pdfUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File("${documentDirectory.path}/$fileName");
    await file.writeAsBytes(response.bodyBytes);

    if (mounted) {
      setState(() {
        downloadedFilePath = file.path;
      });
    }
  }

  String _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.pathSegments.last;
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _getFileNameFromUrl(widget.pdfUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text("$fileName"),
      ),
      body: downloadedFilePath.isNotEmpty
          ? PDFView(
              filePath: downloadedFilePath,
              onRender: (pages) {
                // Do something when rendering is finished
              },
              onError: (error) {
                print(error);
              },
              onPageError: (page, error) {
                print('$page: $error');
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

void navigateToPdfViewer(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/1-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer2(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/2-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer3(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/3-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer4(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/4-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer5(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/5-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer6(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/6-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer7(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/7-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer8(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/8-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer9(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/9-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer10(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/10-Maruza.pdf'),
    ),
  );
}

void lab(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya1.pdf'),
    ),
  );
}

void lab2(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya2.pdf'),
    ),
  );
}

void lab3(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya3.pdf'),
    ),
  );
}

void lab4(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya4.pdf'),
    ),
  );
}

void lab5(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya5.pdf'),
    ),
  );
}

void lab6(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya6.pdf'),
    ),
  );
}

void lab7(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya7.pdf'),
    ),
  );
}

void lab8(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya8.pdf'),
    ),
  );
}

void lab9(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya9.pdf'),
    ),
  );
}

void lab10(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya10.pdf'),
    ),
  );
}

void lab11(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya11.pdf'),
    ),
  );
}

void lab12(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya12.pdf'),
    ),
  );
}

void lab13(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya13.pdf'),
    ),
  );
}

void lab14(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya14.pdf'),
    ),
  );
}

void navigateToPdfViewerp(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              "https://www.pythonanywhere.com/user/sardorbek95/files/home/sardorbek95/static/Darsliklar/lecturesp/1-TAQDIMOT.pptx"),
    ),
  );
}

void navigateToPdfViewerp2(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              "https://www.pythonanywhere.com/user/sardorbek95/files/home/sardorbek95/static/Darsliklar/lecturesp/TAQDIMOT2.pdf"),
    ),
  );
}

void navigateToPdfViewerp3(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/3-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewerp4(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/4-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewerp5(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/5-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewerp6(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/6-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewerp7(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/7-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewerp8(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/8-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewerp9(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/9-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewerp10(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Maruza/10-Maruza.pdf'),
    ),
  );
}

void labp(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya1.pdf'),
    ),
  );
}

void labp2(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya2.pdf'),
    ),
  );
}

void labp3(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya3.pdf'),
    ),
  );
}

void labp4(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya4.pdf'),
    ),
  );
}

void labp5(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya5.pdf'),
    ),
  );
}

void labp6(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya6.pdf'),
    ),
  );
}

void labp7(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya7.pdf'),
    ),
  );
}

void labp8(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya8.pdf'),
    ),
  );
}

void labp9(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya9.pdf'),
    ),
  );
}

void labp10(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya10.pdf'),
    ),
  );
}

void labp11(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya11.pdf'),
    ),
  );
}

void labp12(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya12.pdf'),
    ),
  );
}

void labp13(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya13.pdf'),
    ),
  );
}

void labp14(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(
          pdfUrl:
              'https://hbnnarzullayev.pythonanywhere.com/static/pdf/Laboratory/Laboratoriya14.pdf'),
    ),
  );
}

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _Profilepage();
}

Future<void> fetchScore() async {
  try {
    final response = await http
        .get(Uri.parse('https://hbnnarzullayev.pythonanywhere.com/score'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final score =
          data['score']; // Access the 'score' field in the JSON response
      print('Score: $score');
    } else {
      print('Failed to load score. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

class _Profilepage extends State<Profilepage> {
  int selectedPageIndex = 0;
  void logoutUser() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.login(""); // Clear the username
    authProvider.setLoggedInEmail("");
    void fetchScore() {
      fetchScore();
    } // Clear the email
    // You can also perform any additional logout actions here
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          // Add a logout button to the app bar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logoutUser(); // Call the logout function
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Muvaffaqqiyatli chiqish!'),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              authProvider.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              authProvider.email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: Container(
                child: Image.network(
                    'https://hbnnarzullayev.pythonanywhere.com/static/Image/${authProvider.username}.jpg')),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Bosh sahifa'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.login,
            ),
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.app_registration,
            ),
            title: const Text("Ro'yxatdan o'tish"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('_MyAppState Page'),
      ),
      body: const [
        Center(
          child: Text(
            'Learn 📗',
          ),
        ),
        Center(
          child: Text(
            'Relearn 👨‍🏫',
          ),
        ),
        Center(
          child: Text(
            'Unlearn 🐛',
          ),
        ),
      ][selectedPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Learn',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.engineering),
            icon: Icon(Icons.engineering_outlined),
            label: 'Relearn',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.bookmark_border),
            label: 'Unlearn',
          ),
        ],
      ),
    );
  }
}

class Lectures extends StatelessWidget {
  const Lectures({super.key});

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma'ruzalar"),
      ),
      body: ListView(
        children: [
          SafeArea(
              child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              // Row(
              //   children: [
              //     SizedBox(
              //       height: MediaQuery.of(context).size.height * 0.15,
              //       width: MediaQuery.of(context).size.width,
              //       child: ElevatedButton(
              //         onPressed: () {
              //           navigateToPdfViewer(context);
              //         },
              //         child: const Text(
              //           'Kirish',
              //           style: TextStyle(fontSize: 20),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                color: Colors.blueGrey,
                child: ListTile(
                  leading: const Icon(
                    Icons.chrome_reader_mode,
                    size: 50,
                  ),
                  title: Text(
                    "Kirish. Parazitologiya fanining vazifalari, uning rivojlanishidagi asosiy bosqichlari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer(context);
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
                  title: Text(
                    "Tirik organizmlarning o’zaro munosabatlari va uning asosiy shakllari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer2(context);
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
                  title: Text(
                    "Parazit va xo’jayin orasidagi bog’lanishning turli-tuman shakllari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer3(context);
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
                  title: Text(
                    "Doimiy (stasionar) parazitizm",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer4(context);
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
                  title: Text(
                    "Parazitlarning xo’jayinlari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer5(context);
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
                  title: Text(
                    "Parazitlarning xo’jayin tanasiga kirishi va undan chiqish yo’llari. Parazitizmning qadimiyligi",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer6(context);
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
                  title: Text(
                    "Parazit va xo’jayin orasidagi munosabatlar. Parazitning xo’jayinga ta’siri",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer7(context);
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
                  title: Text(
                    "Xo’jayinning parazitga ta’siri. Tashqi muhit omillarining parazit va xo’jayinga ta’siri",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer8(context);
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
                  title: Text(
                    "Parazitlarning tuzilishi va hayot siklidagi adaptasiyalar",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer9(context);
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
                  title: Text(
                    "Infeksion va invazion kasalliklar. Transmissiv kasalliklar",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewer10(context);
                  },
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class Presents extends StatelessWidget {
  const Presents({super.key});

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Taqdimotlar"),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10.0)),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  color: Colors.blueGrey,
                  child: ListTile(
                    leading: const Icon(
                      Icons.tv,
                      size: 50,
                    ),
                    title: Text(
                      "Ma'ruzalar yuzasidan taqdimotlar",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LecturesP()),
                      );
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10.0)),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  color: Colors.blueGrey,
                  child: ListTile(
                    leading: const Icon(
                      Icons.tv,
                      size: 50,
                    ),
                    title: Text(
                      "Laboratoriya yuzasidan taqdimotlar",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LaboratoryP()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LecturesP extends StatelessWidget {
  const LecturesP({super.key});

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma'ruzalar yuzasidan taqdimotlar"),
      ),
      body: ListView(
        children: [
          SafeArea(
              child: Column(
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
                  title: Text(
                    "Kirish. Parazitologiya fanining vazifalari, uning rivojlanishidagi asosiy bosqichlari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp(context);
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
                  title: Text(
                    "Tirik organizmlarning o’zaro munosabatlari va uning asosiy shakllari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp2(context);
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
                  title: Text(
                    "Parazit va xo’jayin orasidagi bog’lanishning turli-tuman shakllari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PDFapp()),
                    );
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
                  title: Text(
                    "Doimiy (stasionar) parazitizm",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp4(context);
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
                  title: Text(
                    "Parazitlarning xo’jayinlari",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp5(context);
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
                  title: Text(
                    "Parazitlarning xo’jayin tanasiga kirishi va undan chiqish yo’llari. Parazitizmning qadimiyligi",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp6(context);
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
                  title: Text(
                    "Parazit va xo’jayin orasidagi munosabatlar. Parazitning xo’jayinga ta’siri",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp7(context);
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
                  title: Text(
                    "Xo’jayinning parazitga ta’siri. Tashqi muhit omillarining parazit va xo’jayinga ta’siri",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp8(context);
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
                  title: Text(
                    "Parazitlarning tuzilishi va hayot siklidagi adaptasiyalar",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp9(context);
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
                  title: Text(
                    "Infeksion va invazion kasalliklar. Transmissiv kasalliklar",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: () {
                    navigateToPdfViewerp10(context);
                  },
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

class LaboratoryP extends StatelessWidget {
  const LaboratoryP({super.key});

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laboratoriya yuzasidan taqdimotlar"),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: Column(
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
                    title: Text(
                      "Protozooz kasalliklar. Ichburug’ amyobasi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp(context);
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
                    title: Text(
                      "Tripanosomalar va leyshmaniyalar. Tuzilish xususiyatlari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp2(context);
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
                    title: Text(
                      "Qon sporalilari - Haemosporidia. Bezgak parazitlari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp3(context);
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
                    title: Text(
                      "Chorva hayvonlarini ovqat hazm qilish sistemasida yashovchi parazitlar",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp4(context);
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
                    title: Text(
                      "Nashtarsimon (lansetsimon) va mushuk (sibir) so’rg’ichlilari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp5(context);
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
                    title: Text(
                      "Qoramol va cho’chqa solityorlarining tuzilish xususiyatlari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp6(context);
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
                    title: Text(
                      "Keng tasma,  kalta (pakana) zanjir va exinokokklarning tuzilishi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp7(context);
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
                    title: Text(
                      "Odamning parazit nematodalari. Tuzilishi va hayot sikli",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp8(context);
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
                    title: Text(
                      "Odamning parazit nematodalari. Ostrisa, qilbosh nematoda, trixina",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp9(context);
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
                    title: Text(
                      "O’simliklarning turli vegetativ a’zolarida va rizosfera tuprog’ida yashovchi fitonematodalar",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp10(context);
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
                    title: Text(
                      "Fitonematodalardan vaqtinchalik va doimiy preparatlar tayyorlash",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp11(context);
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
                    title: Text(
                      "O’simliklarning parazit nematodalari. Ildiz bo’rtma nematodalari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp12(context);
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
                    title: Text(
                      "Ektoparazit bo’g’imoyoqlilar. Iksod va mol kanasi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp13(context);
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
                    title: Text(
                      "Qon so’ruvchi hasharotlar. Ko’payishi va rivojlanishi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      labp14(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Laboratory extends StatelessWidget {
  const Laboratory({super.key});

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratoriya'),
      ),
      body: ListView(
        children: [
          SafeArea(
            child: Column(
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
                    title: Text(
                      "Protozooz kasalliklar. Ichburug’ amyobasi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab(context);
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
                    title: Text(
                      "Tripanosomalar va leyshmaniyalar. Tuzilish xususiyatlari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab2(context);
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
                    title: Text(
                      "Qon sporalilari - Haemosporidia. Bezgak parazitlari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab3(context);
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
                    title: Text(
                      "Chorva hayvonlarini ovqat hazm qilish sistemasida yashovchi parazitlar",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab4(context);
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
                    title: Text(
                      "Nashtarsimon (lansetsimon) va mushuk (sibir) so’rg’ichlilari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab5(context);
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
                    title: Text(
                      "Qoramol va cho’chqa solityorlarining tuzilish xususiyatlari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab6(context);
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
                    title: Text(
                      "Keng tasma,  kalta (pakana) zanjir va exinokokklarning tuzilishi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab7(context);
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
                    title: Text(
                      "Odamning parazit nematodalari. Tuzilishi va hayot sikli",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab8(context);
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
                    title: Text(
                      "Odamning parazit nematodalari. Ostrisa, qilbosh nematoda, trixina",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab9(context);
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
                    title: Text(
                      "O’simliklarning turli vegetativ a’zolarida va rizosfera tuprog’ida yashovchi fitonematodalar",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab10(context);
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
                    title: Text(
                      "Fitonematodalardan vaqtinchalik va doimiy preparatlar tayyorlash",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab11(context);
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
                    title: Text(
                      "O’simliklarning parazit nematodalari. Ildiz bo’rtma nematodalari",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab12(context);
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
                    title: Text(
                      "Ektoparazit bo’g’imoyoqlilar. Iksod va mol kanasi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab13(context);
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
                    title: Text(
                      "Qon so’ruvchi hasharotlar. Ko’payishi va rivojlanishi",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18,
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onTap: () {
                      lab14(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController pwdcController = TextEditingController();

  Future<void> registerUser() async {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = pwdController.text;
    final String passwordc = pwdcController.text;

    final response = await http.post(
      Uri.parse(
          'https://hbnnarzullayev.pythonanywhere.com/register'), // Replace with your Flask API URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'pwd': password,
        'pwdc': passwordc,
      }),
    );

    if (response.statusCode == 200) {
      // Registration successful, handle the response
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      // You can parse and use the response data here
    } else {
      // Registration failed, handle the error
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Fail()),
      );
      // Handle error responses here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: pwdController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: pwdcController,
              decoration: const InputDecoration(labelText: 'Repeat password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Call the registration function when the button is pressed
                registerUser();
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  final double containerWidthFraction = 0.45;
  final double containerHeightFraction = 0.15;
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  String username = "";
  String email = "";

  Future<void> loginUser() async {
    try {
      final url = Uri.parse('https://hbnnarzullayev.pythonanywhere.com/logins');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nma': usernameController.text,
          'pwda': pwdController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');
        setState(() {
          username = data['username'];
          email = data['email'];
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userToken', 'your_token_here');

        // Update the authProvider here
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.login(username);
        authProvider.setLoggedInEmail(email);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Muvaffaqqiyatli kirish!'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );

        // Navigate to other pages after setting the authProvider
        // Example:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => YourNextPage()),
        // );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Fail()),
        );
      }
    } catch (e) {
      // Handle other exceptions (e.g., network issues) here
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login yoki parol xato.$e'),
        ),
      );
    }
  }

  void logoutUser() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.login(""); // Clear the username
    authProvider.setLoggedInEmail(""); // Clear the email
    // You can also perform any additional logout actions here
  }

  @override
  Widget build(BuildContext context) {
    final double containerWidthFraction = 0.45;
    final double containerHeightFraction = 0.15;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login $username'),
        actions: [
          // Add a logout button to the app bar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              logoutUser(); // Call the logout function
              // Optionally, navigate to the login page or another page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Muvaffaqqiyatli chiqish!'),
                ),
              );
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('userToken');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: pwdController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      0.25,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction *
                      0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      // Call the registration function when the button is pressed
                      loginUser();
                      authProvider.login(username);
                      authProvider.setLoggedInEmail(email);
                    },
                    child: const Text('Login'),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 5.0)),
                Container(
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      0.25,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction *
                      0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text('Register'),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 5.0)),
                Container(
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      0.25,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction *
                      0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyHomePage()),
                      );
                    },
                    child: const Text("Bosh sahifa"),
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

class Quiz extends StatefulWidget {
  final int initialIndex;
  final int initialScore;
  Quiz({required this.initialIndex, required this.initialScore});
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  Future<void> fetchQuizQuestions() async {
    final response = await http.get(Uri.parse(
        'https://hbnnarzullayev.pythonanywhere.com/get_data_as_json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      questions =
          data.map((question) => question as Map<String, dynamic>).toList();
      setState(() {
        currentIndex = 0;
        score = 0;
      });
    } else {
      print('Failed to load questions');
    }
  }

  void answerQuestion(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        score++;
      });
    }
    setState(() {
      currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (currentIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Natijalar'),
        ),
        body: Center(
          child: Column(
            children: [
              TextSectionone('Test tugadi, Sizning ballingiz: $score'),
              ElevatedButton(
                onPressed: () {
                  sendQuizResults(score,
                      authProvider.username); // Use authProvider.username here
                },
                child: Text('Javobni tasdiqlash'),
              ),
            ],
          ),
        ),
      );
    } else {
      final question = questions[currentIndex];
      final List<String> choices = (question['choices'] as List).cast<String>();
      final String correctAnswer = question['correct_answer'] as String;
      return Scaffold(
        appBar: AppBar(
          title: Text('Test savollari'),
        ),
        body: QuizQuestion(
          questionText: question['question'] as String,
          choices: choices,
          correctAnswer: correctAnswer,
          onAnswer: answerQuestion,
        ),
      );
    }
  }

  Future<void> sendQuizResults(int score, String name) async {
// Add listen: false here
    final response = await http.post(
      Uri.parse('https://hbnnarzullayev.pythonanywhere.com/api/scores'),
      body: json.encode({'score': score, 'user': name}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Score submitted successfully'); // Call the logout function
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Websaytga yuklandi!'),
        ),
      );
    } else {
      // Handle the error
      print('Internet aloqa sifati yaxshi emas!');
    }
  }
}

class QuizQuestion extends StatelessWidget {
  final String questionText;
  final List<String> choices;
  final String correctAnswer;
  final Function(bool) onAnswer;

  QuizQuestion({
    required this.questionText,
    required this.choices,
    required this.correctAnswer,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final double containerHeightFraction = 0.15;
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01)),
        Container(
          height: MediaQuery.of(context).size.height *
              containerHeightFraction *
              0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color.fromARGB(255, 54, 171, 244),
          ),
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02),
          child: Text(questionText),
        ),
        Column(
          children: choices.map((answer) {
            return ElevatedButton(
              onPressed: () {
                onAnswer(answer == correctAnswer);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: MediaQuery.of(context).size.height *
                    containerHeightFraction *
                    0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Text(answer),
              ),
            );
          }).toList(),
        ),
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.55)),
        Container(
          height: MediaQuery.of(context).size.height *
              containerHeightFraction *
              0.25,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
            child: const Text("Bosh sahifa"),
          ),
        ),
      ],
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
  });

  final String url;

  final DataSourceType dataSourceType;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.network(widget.url);
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri:
        _videoPlayerController =
            VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }

    _videoPlayerController.initialize().then(
          (_) => setState(
            () => _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: 16 / 9,
            ),
          ),
        );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "",
        //   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        const Divider(),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _chewieController != null
              ? Chewie(controller: _chewieController)
              : CircularProgressIndicator(),
        ),
      ],
    );
  }
}

class VideoPlayersScreen extends StatelessWidget {
  const VideoPlayersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Players')),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            SizedBox(
              child: Column(
                children: [
                  Text(
                    "1-Video. Cho'chqa tasmasimoni",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Local Assets
            VideoPlayerView(
              url: 'assets/videos/1-video.mp4',
              dataSourceType: DataSourceType.asset,
            ),
            SizedBox(height: 24),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    "2-Video",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            VideoPlayerView(
              url: 'assets/videos/2-video.mp4',
              dataSourceType: DataSourceType.asset,
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    "3-Video",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            VideoPlayerView(
              url: 'assets/videos/3-video.mp4',
              dataSourceType: DataSourceType.asset,
            ),
            SizedBox(
              child: Column(
                children: [
                  Text(
                    "4-Video",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            VideoPlayerView(
              url: 'assets/videos/4-video.mp4',
              dataSourceType: DataSourceType.asset,
            ),
            // // Network
            // VideoPlayerView(
            //   url:
            //   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
            //   dataSourceType: DataSourceType.network,
            // ),
          ],
        ),
      ),
    );
  }
}

class PDFapp extends StatefulWidget {
  @override
  _PDFapp createState() => _PDFapp();
}

class _PDFapp extends State<PDFapp> {
  String pathPDF = "";
  String pathPDF2 = "";
  String pathPDF3 = "";

  @override
  void initState() {
    super.initState();
    fromAsset('assets/PPTLectuer/TAQDIMOT1.pdf', 'TAQDIMOT1.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/TAQDIMOT2.pdf', 'TAQDIMOT2.pdf').then((f) {
      setState(() {
        pathPDF2 = f.path;
      });
    });
    fromAsset('assets/PPTLectuer/TAQDIMOT1.pdf', 'TAQDIMOT1.pdf').then((f) {
      setState(() {
        pathPDF3 = f.path;
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
    final themeData = Theme.of(context);
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Tap to Open Document',
                        style: themeData.textTheme.headline4
                            ?.copyWith(fontSize: 21.0)),
                    onPressed: () {
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
                  ElevatedButton(
                    child: Text('Tap to Open Document',
                        style: themeData.textTheme.headline4
                            ?.copyWith(fontSize: 21.0)),
                    onPressed: () {
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
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    color: Colors.blueGrey,
                    child: ListTile(
                      leading: const Icon(
                        Icons.chrome_reader_mode,
                        size: 50,
                      ),
                      title: Text(
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
                              builder: (context) => PDFScreen(path: pathPDF3),
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

// class PDFpage extends StatefulWidget {
//   const PDFpage({Key? key}) : super(key: key);
//
//   @override
//   State<PDFpage> createState() => _HomePage();
// }
//
// class _HomePage extends State<PDFpage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Syncfusion Flutter PDF Viewer'),
//       ),
//       body: SfPdfViewer.asset(
//         'assets/PPTLectuer/TAQDIMOT1.pdf',
//       ),
//     );
//   }
// }
