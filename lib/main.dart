// import 'dart:js';

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:internet_file/internet_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'image_banner.dart';
import 'text_section.dart';
import 'dart:async';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
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

// void navigateToPdfViewer(BuildContext context) {
//   Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => PdfViewerPage(pdfAsset: 'assets/images/Maruza1.pdf',),
//   ),
// );
//
// }

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

    if (storedEmail != null &&
        storedIsLoggedIn != null &&
        storedIsLoggedIn) {
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
        title: const Text('Salomlar'),
        centerTitle: true,
        actions: [
          Center(
            child: Text(authProvider.username),
          )
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
                currentAccountPicture: const Image(image: NetworkImage('https://hbnnarzullayev.pythonanywhere.com/static/logo-no-background.png')),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                ),
                title: const Text('Profile'),
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
                  Icons.train,
                ),
                title: const Text('Page 2'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp1()),
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
                applicationName: 'My Cool App',
                applicationVersion: '1.0.25',
                applicationLegalese: '©hbn_company',
                aboutBoxChildren: [
                  Image(image: NetworkImage('https://hbnnarzullayev.pythonanywhere.com/static/logo-no-background.png'))
                ],
                child: Text('About app'),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 5.0)),
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
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage('assets/images/unnamed.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.1,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Lectures()),
                    );
                  },
                  child: TextSection(authProvider.username, 'Travel'),
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
                      MaterialPageRoute(builder: (context) => Lectures()),
                    );
                  },
                  child: TextSection('SUMMARY1', 'Travel'),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 5.0)),
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
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage('assets/images/unnamed.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.1,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Lectures()),
                    );
                  },
                  child: Column(
                    children: [
                      TextSection('BOOK', 'Travel'),
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
                      MaterialPageRoute(builder: (context) => Lectures()),
                    );
                  },
                  child: TextSection('SUMMARY1', 'Travel'),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 5.0)),
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
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage('assets/images/unnamed.jpg'),
                    fit: BoxFit.fill,
                    opacity: 0.1,
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Lectures()),
                    );
                  },
                  child: TextSection('Lectures', 'Lectures'),
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
                  child: TextSection('QuizApp', 'QuizApp'),
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
        title: const Text('Kirish. Parazitologiya fanining vazifalari, uning rivojlanishidagi asosiy bosqichlari', style: TextStyle(fontSize: 15),),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Merged_document.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}

class M2 extends StatelessWidget {
  const M2 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirik organizmlarning o’zaro munosabatlari va uning asosiy shakllari'),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}
class M3 extends StatelessWidget {
  const M3 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parazit va xo’jayin orasidagi bog’lanishning turli-tuman shakllari'),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}
class M4 extends StatelessWidget {
  const M4 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("'Doimiy (stasionar) parazitizm' Doimiy (stasionar) parazitizm"),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}
class M5 extends StatelessWidget {
  const M5 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parazitlarning xo'jayinlari"),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}

class M6 extends StatelessWidget {
  const M6 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parazitlarning xo’jayin tanasiga kirishi va undan chiqish yo’llari. Parazitizmning qadimiyligi"),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}

class M7 extends StatelessWidget {
  const M7 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parazit va xo’jayin orasidagi munosabatlar. Parazitning xo’jayinga ta’siri"),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}

class M8 extends StatelessWidget {
  const M8 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xo’jayinning parazitga ta’siri."),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}

class M9 extends StatelessWidget {
  const M9 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parazitlarning tuzilishi va hayot siklidagi adaptasiyalar."),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpeg', fit: BoxFit.scaleDown,)],
        ),
      ),
    );
  }
}

class M10 extends StatelessWidget {
  const M10 ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infeksion va invazion kasalliklar", style: TextStyle(fontSize: 15),),
      ),
      body: Scaffold(
        body: ListView(children:[Image.asset('assets/images/Glossariy.jpg', fit: BoxFit.scaleDown,)],
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

// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({super.key});
//
//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }
//
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   static const int _initialPage = 1;
//   late PdfController _pdfController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pdfController = PdfController(
//       document:
//           PdfDocument.openData(InternetFile.get('sample/assets/ISORA1.docx')),
//       initialPage: _initialPage,
//     );
//   }
//
//   @override
//   void dispose() {
//     _pdfController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter PDF Example'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.navigate_before),
//             onPressed: () {
//               _pdfController.previousPage(
//                 curve: Curves.ease,
//                 duration: const Duration(milliseconds: 100),
//               );
//             },
//           ),
//           PdfPageNumber(
//             controller: _pdfController,
//             builder: (_, loadingState, page, pagesCount) => Container(
//               alignment: Alignment.center,
//               child: Text(
//                 '$page/${pagesCount ?? 0}',
//                 style: const TextStyle(fontSize: 22),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.navigate_next),
//             onPressed: () {
//               _pdfController.nextPage(
//                 curve: Curves.ease,
//                 duration: const Duration(milliseconds: 100),
//               );
//             },
//           ),
//         ],
//       ),
//       body: PdfView(
//         builders: PdfViewBuilders<DefaultBuilderOptions>(
//           options: const DefaultBuilderOptions(),
//           documentLoaderBuilder: (_) =>
//               const Center(child: CircularProgressIndicator()),
//           pageLoaderBuilder: (_) =>
//               const Center(child: CircularProgressIndicator()),
//         ),
//         controller: _pdfController,
//       ),
//     );
//   }
// }

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

// class PdfViewerPage extends StatelessWidget {
//   final String pdfAsset; // Replace this with your PDF file asset path
//
//   PdfViewerPage({required this.pdfAsset});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("PDF Viewer"),
//       ),
//       body: PDFView(
//         filePath: pdfAsset,
//         // Use `filePath` if your PDF is on the device
//         // Use `asset` if your PDF is in the assets folder
//         // asset: pdfAsset,
//         // or
//         // network: "https://example.com/your.pdf",
//         // if your PDF is hosted online
//         onRender: (pages) {
//           // Do something when rendering is finished
//         },
//         onError: (error) {
//           print(error);
//         },
//         onPageError: (page, error) {
//           print('$page: $error');
//         },
//       ),
//     );
//   }
// }

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  PdfViewerPage({required this.pdfUrl});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late String downloadedFilePath;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    final response = await http.get(Uri.parse(widget.pdfUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File("${documentDirectory.path}/your_pdf_filename.pdf");
    await file.writeAsBytes(response.bodyBytes);

    if (mounted) {
      setState(() {
        downloadedFilePath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
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
      builder: (context) => PdfViewerPage(pdfUrl: 'https://hbnnarzullayev.pythonanywhere.com/static/pdf/1-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer2(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(pdfUrl: 'https://sardorbek95.pythonanywhere.com/Maruza/2-Maruza.pdf'),
    ),
  );
}

void navigateToPdfViewer3(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfViewerPage(pdfUrl: 'https://sardorbek95.pythonanywhere.com/Maruza/3-Maruza.pdf'),
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
    final response = await http.get(Uri.parse('https://hbnnarzullayev.pythonanywhere.com/score'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final score = data['score']; // Access the 'score' field in the JSON response
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
        title: const Text('Profile Page'),
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
            currentAccountPicture: Container(child: Image.network('https://hbnnarzullayev.pythonanywhere.com/static/Image/${authProvider.username}.jpg')),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Home'),
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
            title: const Text('Registration'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationPage()),
              );
            },
          ),
          const AboutListTile(
            icon: Icon(
              Icons.info,
            ),
            applicationIcon: Icon(
              Icons.local_play,
            ),
            applicationName: 'My Cool App',
            applicationVersion: '1.0.25',
            applicationLegalese: '© 2023 Company',
            aboutBoxChildren: [],
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
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
        title: const Text('Lectures'),
      ),
      body: ListView(
        children: [
          SafeArea(
              child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        navigateToPdfViewer(context);
                      },
                      child: const Text(
                        'Kirish',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        navigateToPdfViewer2(context);
                      },
                      child: const Text(
                        '2-Mavzu',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        navigateToPdfViewer3(context);
                      },
                      child: const Text(
                        'Kirish',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const M4()),
                        );
                      },
                      child: const Text(
                        "4-Ma'ruza",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const M5()),
                        );
                      },
                      child: const Text(
                        "5-Ma'ruza",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const M6()),
                        );
                      },
                      child: const Text(
                        "6-Ma'ruza",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const M7()),
                        );
                      },
                      child: const Text(
                        "7-Ma'ruza",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const M8()),
                        );
                      },
                      child: const Text(
                        "8-Ma'ruza",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const M9()),
                        );
                      },
                      child: const Text(
                        "9-Ma'ruza",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const M10()),
                        );
                      },
                      child: const Text(
                        "10-Ma'ruza",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
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
        Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.01)),
        Container(
          height: MediaQuery.of(context).size.height *
              containerHeightFraction *
              0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color.fromARGB(255, 54, 171, 244),
          ),
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.height *0.02),
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
        Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.55)),
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
