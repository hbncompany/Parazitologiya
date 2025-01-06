import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:internet_file/internet_file.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'image_banner.dart';
import 'text_section.dart';
import 'YouTubeVideoPage.dart';
import 'pdfwiever.dart';
import 'Lecture.dart';
import 'circle.dart';
import 'dart:async';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
    _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Initialize SharedPreferences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()..checkLoginStatus()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class AuthProvider with ChangeNotifier {
  String _username = "";
  String _password = "";
  String _email = "";
  int _score = 0;
  String _summscore = "";
  int _countscore = 0;
  bool _isLoggedIn = false;

  String get username => _username;
  String get password => _password;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;
  List<int> _quizResults = [];
  List<int> get quizResults => _quizResults;

  int get score => _score;

  void setscore(int score) {
    _score = score;
    notifyListeners();
    print(score);
  }

  set score(int _score) {}

  void summsetscore(String summscore) {
    _summscore = summscore;
    notifyListeners();
    print(summscore);
  }

  set summscore(int _summscore) {}

  int get countscore => _countscore;
  void countsetscore(int countscore) {
    _countscore = countscore;
    notifyListeners();
    print(countscore);
  }

  set countscore(int _countscore) {}

  void addQuizResult(int result) {
    _quizResults.add(result);
    notifyListeners();
  }

  Future<void> login(String username) async {
    // Perform your login logic here

    // If login is successful, set the username and login status
    _username = username;
    _email = email;
    _password = password;
    _isLoggedIn = true;

    // Store the user login details in shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    prefs.setString('email', email);
    prefs.setInt('score', score);
    prefs.setBool('isLoggedIn', true);
    print(password);

    notifyListeners();
  }

  bool isTeacher() {
    return _username == 'Teacher' && _password == '12345';
  }

  void setLoggedInEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void fetchScore(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.refreshScore();
  }

  Future<void> refreshScore() async {
    try {
      // Make an API call to fetch the user's score
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/users_scores'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nms': _username, 'app': 2}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final score = data['last_score'];
        final summscore = data["summ_score"];
        final countscore = data['count_score'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('score', score);

        // Update the score in the AuthProvider
        setscore(score);
        summsetscore(summscore);
        countsetscore(countscore);
        notifyListeners();
        // Show a success message (optional)
        print('Score updated successfully');
      } else {
        // Handle the case where fetching score failed
        print('Failed to fetch score. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any other errors that may occur
      print('Error: $error');
    }
  }

  Future<void> logout() async {
    // Perform your logout logic here

    // Clear user login details from shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('isLoggedIn');

    // Reset the username and login status
    _username = "";
    _password = '';
    _isLoggedIn = false;

    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    _password = prefs.getString('password') ?? "";
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
Future<void> _requestPermissions() async {
  // Request permission to access external storage
  var status = await Permission.storage.request();

  if (status.isGranted) {
    print("Storage permission granted");
  } else {
    print("Storage permission denied");
    // You can show a dialog explaining why the permission is needed.
  }
}

class ThemeModel with ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeModel() {
    _loadThemeMode();
  }

  ThemeMode get mode => _mode;

  void toggleMode() {
    if (_mode == ThemeMode.light) {
      _mode = ThemeMode.dark;
    } else {
      _mode = ThemeMode.light;
    }
    _saveThemeMode();
    notifyListeners();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode') ?? 'light';
    _mode = themeString == 'light' ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', _mode == ThemeMode.light ? 'light' : 'dark');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_, model, __) {
          return MaterialApp(
            theme: darkTheme, // Set the initial theme to light
            darkTheme: ThemeData.light(), // Provide dark theme.
            themeMode: model.mode,
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double containerWidthFraction = 0.45;
  final double containerHeightFraction = 0.15;

  @override
  void initState() {
    super.initState();
    // Automatically run fetchScore when the page is loaded
    fetchScore(context);
  }

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
    final model = Provider.of<ThemeModel>(context);
    final themeProvider = Provider.of<ThemeNotifier>(context);
    int selectedPageIndex = 0;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('M i k r o b i ol o g i y a'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profilepage()),
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
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                  ),
                  accountName: Text(
                    authProvider.username == null ||
                        authProvider.username.isEmpty
                        ? 'MEHMON'
                        : authProvider.username,
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
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Image.network(
                      authProvider.username == null ||
                          authProvider.username.isEmpty
                          ? 'assets/images/default.jpg'
                          : 'https://hbnnarzullayev.pythonanywhere.com/static/Image/${authProvider.username}.jpg',
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/default.png');
                      },
                    ),
                  ),
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
                // ListTile(
                //   leading: const Icon(
                //     Icons.person,
                //   ),
                //   title: const Text("So'z boshi"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const Soz_boshi()),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.person,
                //   ),
                //   title: const Text("Mualliflar"),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const SecondScreen()),
                //     );
                //   },
                // ),
                const AboutListTile(
                  icon: Icon(
                    Icons.info,
                  ),
                  applicationIcon: Icon(
                    Icons.person_2_outlined,
                  ),
                  applicationName: 'MIKROBIOLOGIYA',
                  applicationVersion: '1.0.1',
                  applicationLegalese: 'Telegram: @hbn_company',
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.white,
                            Colors.tealAccent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade900,
                              spreadRadius: 5,
                              blurRadius: 15),
                        ],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        color: Color(0xffefeeee),
                      ),
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 6)),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            // width: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Oxirgi test natijasi:",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                shadows: [
                                  Shadow(
                                    color: Color(
                                        0xff070707), // Choose the color of the shadow
                                    blurRadius:
                                    2.0, // Adjust the blur radius for the shadow effect
                                    offset: Offset(1.5,
                                        1.5), // Set the horizontal and vertical offset for the shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // const Padding(padding: EdgeInsets.only(left: 25)),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${authProvider.score} ball",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff0456ef),
                                fontSize: 40,
                                shadows: [
                                  Shadow(
                                    color: Color(
                                        0xff070707), // Choose the color of the shadow
                                    blurRadius:
                                    2.0, // Adjust the blur radius for the shadow effect
                                    offset: Offset(1.5,
                                        1.5), // Set the horizontal and vertical offset for the shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.07,
                            height: 50,
                            decoration:
                            BoxDecoration(color: Colors.transparent),
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              color: Colors.blue,
                              onPressed: () {
                                fetchScore(context);
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      1.2,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction,
                  decoration: const BoxDecoration(
                    color: Color(0x69027ee5),
                    // border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/Lecture.jpeg'),
                        fit: BoxFit.fill),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Lek_page()),
                      );
                    },
                    child: TextSectiontwo("Ma'ruzalar"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      1.2,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction,
                  decoration: const BoxDecoration(
                    color: Color(0x69027ee5),
                    // border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/presentations.png'),
                        fit: BoxFit.fill),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Ppt_page()),
                      );
                    },
                    child: TextSectiontwo('Taqdimot'),
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 25.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      1.2,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/labs.jpg'),
                      fit: BoxFit.fill,
                      // opacity: 0.8,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Lab_page()),
                      );
                    },
                    child: TextSectiontwo("Amaliy\nmashg'ulotlar"),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                //   height: MediaQuery.of(context).size.height *
                //       containerHeightFraction *
                //       1.2,
                //   width: MediaQuery.of(context).size.width *
                //       containerWidthFraction,
                //   decoration: const BoxDecoration(
                //     color: Color(0x69027ee5),
                //     // border: Border.all(color: Colors.blue, width: 1),
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //     image: DecorationImage(
                //         image: AssetImage('assets/images/Glossary.png'),
                //         fit: BoxFit.fill),
                //   ),
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const Glossariy()),
                //       );
                //     },
                //     child: TextSectiontwo('Glossariy'),
                //   ),
                // )
                Container(
                  padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      1.2,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction,
                  decoration: const BoxDecoration(
                    color: Color(0x69027e5),
                    // border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/Books.jpg'),
                        fit: BoxFit.fill),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YouTubeVideoListScreen(
                          ),
                        ),
                      );
                    },
                    child: TextSectiontwo('Video darslik'),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 25.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
                  padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      1.2,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction*2.1,
                  decoration: const BoxDecoration(
                    color: Color(0x69027ee5),
                    // border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/quiz.jpg'),
                        fit: BoxFit.fill),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizTypesPage (
                          ),
                        ),
                      );
                    },
                    child: TextSectiontwo('Test savollari'),
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
              'assets/images/Mualliflars.jpg',
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }
}

class Soz_boshi extends StatelessWidget {
  const Soz_boshi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "So'z boshi",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Scaffold(
        body: ListView(
          children: [
            Image.asset(
              'assets/images/So_z-boshi.jpg',
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

class Adabiyotlar extends StatelessWidget {
  const Adabiyotlar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adabiyotlar",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Scaffold(
        body: ListView(
          children: [
            Image.asset(
              'assets/images/Adabiyotlar.jpg',
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }
}

class Succes extends StatelessWidget {
  const Succes({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Natijalar!'),
        actions: [
          // Add a logout button to the app bar
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              fetchScore(context); // Call the logout function
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test natijalari yangilanmoqda!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.only(right: 0)),
            Container(
              // height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade900,
                      spreadRadius: 5,
                      blurRadius: 15),
                ],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffefeeee),
              ),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Test natijalari",
                      style: TextStyle(color: Colors.blue, fontSize: 25),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade900,
                            spreadRadius: 5,
                            blurRadius: 15),
                      ],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      color: Color(0xffefeeee),
                    ),
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          // width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Oxirgi test natijasi:",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Color(
                                      0xff070707), // Choose the color of the shadow
                                  blurRadius:
                                  2.0, // Adjust the blur radius for the shadow effect
                                  offset: Offset(1.5,
                                      1.5), // Set the horizontal and vertical offset for the shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const Padding(padding: EdgeInsets.only(left: 20)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${authProvider.score} ball",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff0456ef),
                              fontSize: 40,
                              shadows: [
                                Shadow(
                                  color: Color(
                                      0xff070707), // Choose the color of the shadow
                                  blurRadius:
                                  2.0, // Adjust the blur radius for the shadow effect
                                  offset: Offset(1.5,
                                      1.5), // Set the horizontal and vertical offset for the shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(color: Colors.transparent),
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            color: Colors.blue,
                            onPressed: () {
                              fetchScore(context);
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade900,
                            spreadRadius: 1,
                            blurRadius: 15),
                      ],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffefeeee),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Jami test natijalari:",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                color: Color(
                                    0xff070707), // Choose the color of the shadow
                                blurRadius:
                                2.0, // Adjust the blur radius for the shadow effect
                                offset: Offset(1.5,
                                    1.5), // Set the horizontal and vertical offset for the shadow
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5.0)),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.49,
                                    child: Text(
                                      'Urinishlar soni:',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  child: Text(
                                    "${authProvider.countscore}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff0456ef),
                                      fontSize: 40,
                                      shadows: [
                                        Shadow(
                                          color: Color(
                                              0xff070707), // Choose the color of the shadow
                                          blurRadius:
                                          2.0, // Adjust the blur radius for the shadow effect
                                          offset: Offset(1.5,
                                              1.5), // Set the horizontal and vertical offset for the shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      'Umumiy natija:',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  child: Text(
                                    "${authProvider._summscore}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff0456ef),
                                      fontSize: 40,
                                      shadows: [
                                        Shadow(
                                          color: Color(
                                              0xff070707), // Choose the color of the shadow
                                          blurRadius:
                                          2.0, // Adjust the blur radius for the shadow effect
                                          offset: Offset(1.5,
                                              1.5), // Set the horizontal and vertical offset for the shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  const Padding(padding: EdgeInsets.only(left: 10.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade900,
                                spreadRadius: 5,
                                blurRadius: 15),
                          ],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: Color(0xffefeeee),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                          child: Text("Bosh sahifa", style: TextStyle(
                            color: model.mode == ThemeMode.light
                                ? Colors.white30
                                : Colors.lightBlueAccent,),),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 8.0)),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade900,
                                spreadRadius: 5,
                                blurRadius: 15),
                          ],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: Color(0xffefeeee),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(
                                  username: authProvider.username,
                                    scienceName: 'Mikro'
                                ),
                              ),
                            );
                          },
                          child: Text("Test"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Profilepages extends StatefulWidget {
  const Profilepages({super.key});

  @override
  State<Profilepages> createState() => _Profilepages();
}

class _Profilepages extends State<Profilepages> {
  File? _image;
  int selectedPageIndex = 0;
  void logoutUser() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.login(""); // Clear the username
    authProvider.setLoggedInEmail("");
    authProvider.setscore(0);
    // You can also perform any additional logout actions here
  }

  Future<void> _uploadPhoto() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rasm tanlanmadi!')), // No image selected
      );
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://hbnnarzullayev.pythonanywhere.com/api/upload_img'),
    )..fields['user_id'] =
        authProvider.username; // Sending the username as user_id

    // Read the image file as bytes
    List<int> imageBytes = await _image!.readAsBytes();
    http.MultipartFile file = http.MultipartFile.fromBytes(
      'photo', // The field name for the file in Flask
      Uint8List.fromList(imageBytes),
      filename: 'user_photo.jpg',
    );

    request.files.add(file); // Add the image file to the request

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Muvaffaqqiyatli yangilandi!')), // Successful upload message
        );
        await _saveImageLocally(imageBytes);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload: ${response.statusCode}')),
        );
      }
    } catch (error) {
      String errorMessage =
          'Xatolik yuz berdi! Iltimos, qaytadan urinib ko\'ring.';
      if (error is http.ClientException) {
        errorMessage =
        'Tarmoq xatosi. Internetga ulanishni tekshirib ko\'ring.';
      } else if (error is TimeoutException) {
        errorMessage =
        'Xizmat kutish vaqti tugadi. Iltimos, keyinroq urinib ko\'ring.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _saveImageLocally(List<int> imageBytes) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Use the path_provider package to get the local directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = authProvider.username == null
        ? 'assets/images/default.jpg'
        : '${directory.path}/${authProvider.username}_profile.jpg';
    final file = File(filePath);

    await file.writeAsBytes(imageBytes);
    print('Image saved locally at $filePath');
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil rasmini o'zgartirish"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? CircleAvatar(
              radius: 80,
              backgroundImage: FileImage(_image!),
            )
                : CircleAvatar(
              radius: 80,
              child: Icon(Icons.person, size: 80),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _pickImage();
              },
              child: Text('Rasm tanlash'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _uploadPhoto();
              },
              child: Text('Rasmni yuklash'),
            ),
          ],
        ),
      ),
    );
  }
}

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _Profilepage();
}

Future<void> fetchScore(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  try {
    final url =
    Uri.parse('https://hbnnarzullayev.pythonanywhere.com/users_scores');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nms': authProvider.username,
        'app': 2,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      int score = data['last_score'];
      final summscore = data['summ_score'];
      final countscore = data['count_score'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', 'your_token_here');

      // Update the authProvider here
      authProvider.fetchScore(context);
      authProvider.setscore(score);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Muvaffaqqiyatli yangilandi!'),
        ),
      );
    } else {
      print(
          'Xato. Internet yoq yoki test topshirilmagan: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

class _Profilepage extends State<Profilepage> {
  void initState() {
    super.initState();
    // Call fetchScore when the app is loaded
    fetchScore(context);
  }

  File? _image;
  int selectedPageIndex = 0;
  void logoutUser() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.login(""); // Clear the username
    authProvider.setLoggedInEmail("");
    authProvider.setscore(0);
    // You can also perform any additional logout actions here
  }

  Future<void> fetchStudentScores() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await http.get(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/api/studentcores'),
      );
      print(authProvider.username);
      print(authProvider.password);
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Get the directory for saving the file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/student_scores.xlsx';

        // Write the bytes to an Excel file
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        // Notify the user of success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fayl saqlandi: $filePath'),
          ),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to fetch data. HTTP status: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (error) {
      // Handle any errors
      print('Error fetching student scores: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download data. Try again later.'),
        ),
      );
    }
  }

  void _exportToExcel(
      List<dynamic> data, String fileName, BuildContext context) async {
    // Request manage external storage permission before proceeding with file operations
    if (await Permission.manageExternalStorage.request().isGranted) {
      // Permission granted, proceed with file operation

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Add headers
      sheet.appendRow(data[0].keys.toList());

      // Add data
      for (var item in data) {
        sheet.appendRow(item.values.toList());
      }

      // Ask the user to select a directory to save the file
      final result = await FilePicker.platform.getDirectoryPath();

      // If a directory is selected, save the file there
      if (result != null) {
        final filePath = '$result/$fileName.xlsx';
        final file = File(filePath);

        try {
          // Write the file
          await file.writeAsBytes(excel.encode()!);

          // Only show Snackbar if the widget is still mounted
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Saqlandi: $filePath')),
            );

            // Share the file
            Share.shareFiles([filePath], text: 'Excelni ulashish!');
          }

          print('File saved at: $filePath');
        } catch (e) {
          // Handle errors while writing the file
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving file: $e')),
            );
          }
        }
      } else {
        // If no directory was selected
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Directory selection cancelled')),
          );
        }
      }
    } else {
      // If permission is denied, show an error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    }
  }

  void _fetchMineResults(BuildContext context, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/api/mine_result'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': authProvider.username,
          'password': password,
          'app_id': 2,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        _exportToExcel(data, 'MyResults', context);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Results exported successfully!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Test natijalarni yuklashda xatolik. Status: ${response.statusCode}',
              ),
            ),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  void _fetchStudentResults(BuildContext context, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/api/testscores'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'password': password,
          'app_id': 2,}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        _exportToExcel(data, 'StudentResults', context);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fayl muvaffaqqiyatli saqlandi')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Parol xato bo'lishi mumkin")),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Natijalarni yuklashda xatolik")),
        );
      }
    }
  }

  void _showStudentPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Parolni kiriting'),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final password = passwordController.text.trim();
                if (password.isNotEmpty) {
                  _fetchStudentResults(context, password);
                }
              },
              child: const Text(
                'Tasdiqlash',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Bekor qilish',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMineOrStudentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tanlang'),
          content: const Text("Barchaning/shaxsiy test natijalarini yuklash"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchMineResults(context, '12345');
              },
              child: const Text(
                'Shaxsiy',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showStudentPasswordDialog(context);
              },
              child: const Text(
                'Barchaning',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Bekor qilish',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          // Add a logout button to the app bar
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              fetchScore(context); // Call the logout function
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Test natijalari yangilanmoqda!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black38,
              ),
              accountName: Text(
                authProvider.username == null ||
                    authProvider.username.isEmpty
                    ? 'MEHMON'
                    : authProvider.username,
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
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: Image.network(
                  authProvider.username == null ||
                      authProvider.username.isEmpty
                      ? 'assets/images/default.jpg'
                      : 'https://hbnnarzullayev.pythonanywhere.com/static/Image/${authProvider.username}.jpg',
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/default.png');
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
              child: ListTile(
                leading: Icon(
                  Icons.home, color: model.mode == ThemeMode.light
                    ? Colors.white
                    : Colors.lightBlueAccent,
                ),
                title: Text("Bosh sahifa", style: TextStyle(
                color: model.mode == ThemeMode.light
                ? Colors.white
                    : Colors.lightBlueAccent,),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
              child: ListTile(
                leading: Icon(
                  Icons.login, color: model.mode == ThemeMode.light
                    ? Colors.white
                    : Colors.lightBlueAccent,
                ),
                title: Text('Kirish', style: TextStyle(
                  color: model.mode == ThemeMode.light
                      ? Colors.white
                      : Colors.lightBlueAccent,),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
              child: ListTile(
                leading: Icon(
                  Icons.change_circle, color: model.mode == ThemeMode.light
                ? Colors.white
                  : Colors.lightBlueAccent,
                ),
                title: Text("Profil rasmini o'zgartirish", style: TextStyle(
                  color: model.mode == ThemeMode.light
                      ? Colors.white
                      : Colors.lightBlueAccent,),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Profilepages()),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
              child: ListTile(
                leading: Icon(
                  Icons.logout, color: model.mode == ThemeMode.light
                ? Colors.white
                  : Colors.lightBlueAccent,
                ),
                title: Text('Chiqish', style: TextStyle(
                  color: model.mode == ThemeMode.light
                      ? Colors.white
                      : Colors.lightBlueAccent,),),
                onTap: () {
                  logoutUser(); // Call the logout function
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Muvaffaqqiyatli chiqish!'),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black38),
              child: ListTile(
                leading: Icon(Icons.query_stats, color: model.mode == ThemeMode.light
                ? Colors.white
                    : Colors.lightBlueAccent,),
                title: Text('Natijalarim', style: TextStyle(
                  color: model.mode == ThemeMode.light
                      ? Colors.white
                      : Colors.lightBlueAccent,),),
                onTap: () {
                  _showMineOrStudentsDialog(context);
                },
              ),
            ),
            if (authProvider.isTeacher()) ...[
              ElevatedButton(
                onPressed: () async {
                  await fetchStudentScores();
                },
                child: const Text('Talabalar natijalarini yuklash'),
              ),
            ],
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade900,
                      spreadRadius: 5,
                      blurRadius: 15),
                ],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white54,
              ),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Test natijalari",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 30,
                        shadows: [
                          Shadow(
                            color: Color(
                                0xff949393), // Choose the color of the shadow
                            blurRadius:
                            2.0, // Adjust the blur radius for the shadow effect
                            offset: Offset(1.5,
                                1.5), // Set the horizontal and vertical offset for the shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.white,
                          Colors.tealAccent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade900,
                            spreadRadius: 5,
                            blurRadius: 15),
                      ],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      color: Color(0xffefeeee),
                    ),
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 6)),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          // width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Oxirgi test natijasi:",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                  color: Color(
                                      0xff070707), // Choose the color of the shadow
                                  blurRadius:
                                  2.0, // Adjust the blur radius for the shadow effect
                                  offset: Offset(1.5,
                                      1.5), // Set the horizontal and vertical offset for the shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const Padding(padding: EdgeInsets.only(left: 25)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${authProvider.score} ball",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff0456ef),
                              fontSize: 40,
                              shadows: [
                                Shadow(
                                  color: Color(
                                      0xff070707), // Choose the color of the shadow
                                  blurRadius:
                                  2.0, // Adjust the blur radius for the shadow effect
                                  offset: Offset(1.5,
                                      1.5), // Set the horizontal and vertical offset for the shadow
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.07,
                          height: 50,
                          decoration: BoxDecoration(color: Colors.transparent),
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            color: Colors.blue,
                            onPressed: () {
                              fetchScore(context);
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade900,
                            spreadRadius: 1,
                            blurRadius: 15),
                      ],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffefeeee),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Jami test natijalari:",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                color: Color(
                                    0xff070707), // Choose the color of the shadow
                                blurRadius:
                                2.0, // Adjust the blur radius for the shadow effect
                                offset: Offset(1.5,
                                    1.5), // Set the horizontal and vertical offset for the shadow
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5.0)),
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.49,
                                    child: Text(
                                      'Urinishlar soni:',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  child: Text(
                                    "${authProvider.countscore}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff0456ef),
                                      fontSize: 40,
                                      shadows: [
                                        Shadow(
                                          color: Color(
                                              0xff070707), // Choose the color of the shadow
                                          blurRadius:
                                          2.0, // Adjust the blur radius for the shadow effect
                                          offset: Offset(1.5,
                                              1.5), // Set the horizontal and vertical offset for the shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      'Umumiy ball:',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  child: Text(
                                    "${authProvider._summscore}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff0456ef),
                                      fontSize: 40,
                                      shadows: [
                                        Shadow(
                                          color: Color(
                                              0xff070707), // Choose the color of the shadow
                                          blurRadius:
                                          2.0, // Adjust the blur radius for the shadow effect
                                          offset: Offset(1.5,
                                              1.5), // Set the horizontal and vertical offset for the shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                ],
              ),
            ),
          ],
        ),
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
  bool _obscureText = true; // To toggle the visibility of the password
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
          'https://hbnnarzullayev.pythonanywhere.com/register_app'), // Replace with your Flask API URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'pwd': password,
        'pwdc': passwordc,
        'app_id': '2'
      }),
    );

    if (response.statusCode == 200) {
      // Registration successful, handle the response
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Muvaffaqqiyatli ro'yxatdan o'tish!"),
        ),
      );
      // You can parse and use the response data here
    } else {
      // Registration failed, handle the error

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login yoki parol xato'),
        ),
      );
      // Handle error responses here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ro'yxatdan o'tish"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                child: Image.asset('assets/images/logo-no-background.png'),
              ),
              TextFormField(
                controller: usernameController,
                decoration:
                const InputDecoration(labelText: 'Foydalanuvchi nomi'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email (Pochta)'),
              ),
              TextFormField(
                controller: pwdController,
                decoration:
                const InputDecoration(labelText: "Maxfiy so'z (Parol)"),
                obscureText: true,
              ),
              TextFormField(
                controller: pwdcController,
                decoration: const InputDecoration(
                    labelText: "Maxfiy so'zni takrorlang"),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () {
                  // Call the registration function when the button is pressed
                  registerUser();
                },
                child: const Text("Ro'yxatdan o'tish"),
              ),
            ],
          ),
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
  String password = "";
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
          'app_id': 2,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');
        setState(() {
          username = data['username'];
          password = data['password'];
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Muvaffaqqiyatsiz!'),
          ),
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
        // backgroundColor:Colors.red,
        foregroundColor: Colors.blue,
        bottomOpacity: 0.1,
        title: Text('Kirish... $username'),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.black38,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      1.2,
                  child: Image.asset('assets/images/logo-no-background.png'),
                ),
                const Padding(padding: EdgeInsets.only(top: 9.0)),
                const Padding(padding: EdgeInsets.only(left: 9.0)),
                TextFormField(
                  controller: usernameController,
                  decoration:
                  const InputDecoration(labelText: 'Foydalanuvchi nomi'),
                ),
                TextFormField(
                  controller: pwdController,
                  decoration:
                  const InputDecoration(labelText: "Maxfiy so'z (Parol)"),
                  obscureText: true,
                ),
                const Padding(padding: EdgeInsets.only(top: 9.0)),
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height *
                          containerHeightFraction *
                          0.25,
                      width: MediaQuery.of(context).size.width *
                          containerWidthFraction *
                          1,
                      child: ElevatedButton(
                        onPressed: () {
                          // Call the registration function when the button is pressed
                          loginUser();
                          authProvider.login(username);
                          authProvider.setLoggedInEmail(email);
                        },
                        child: const Text('Kirish'),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 9.0)),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          containerHeightFraction *
                          0.25,
                      width: MediaQuery.of(context).size.width *
                          containerWidthFraction *
                          1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistrationPage()),
                          );
                        },
                        child: const Text('Registratsiya'),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 5.0)),
                Container(
                  height: MediaQuery.of(context).size.height *
                      containerHeightFraction *
                      0.25,
                  width: MediaQuery.of(context).size.width *
                      containerWidthFraction *
                      0.7,
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
          ),
        ),
      ),
    );
  }
}

class QuizTypesPage extends StatefulWidget {
  @override
  _QuizTypesPage createState() => _QuizTypesPage();
}

class _QuizTypesPage extends State<QuizTypesPage> {
  late Future<Map<String, dynamic>> quizTypesFuture;
  final double containerWidthFraction = 0.95;
  final double containerHeightFraction = 0.95;

  Future<Map<String, dynamic>> fetchQuizTypes() async {
    try {
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/get_quiz_types'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'app_id': 2,
          'username': Provider.of<AuthProvider>(context, listen: false).username,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure 'is_admin' is converted to a proper boolean
        if (data is Map<String, dynamic>) {
          data['is_admin'] = data['is_admin'] == 'true' || data['is_admin'] == true;
          return data;
        } else {
          throw Exception('Unexpected response format.');
        }
      } else {
        throw Exception('Failed to load quiz types: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz types: $e');
      return {'quiz_types': [], 'is_admin': false};
    }
  }

  @override
  void initState() {
    super.initState();
    quizTypesFuture = fetchQuizTypes();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeModel>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Testlar"),),
        body: Container(
          height:
          MediaQuery.of(context).size.height * containerHeightFraction * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.2,
              image: AssetImage(
                  'assets/images/back.jpg'), // Replace with your image asset path
              fit: BoxFit.fill,
            ),
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: quizTypesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Testlarni yuklashda xatolik"));
              } else if (!snapshot.hasData || snapshot.data!['quiz_types'].isEmpty) {
                return Center(child: Text("Testlar mavjud emas"));
              }

              final quizTypes = List<String>.from(snapshot.data!['quiz_types']);
              final isAdmin = snapshot.data!['is_admin'] as bool;

              return Column(
                children: [
                  if (isAdmin)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddQuizPage()),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text("Yangi test qo'shish"),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: quizTypes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Container(
                            color: model.mode == ThemeMode.light
                                ? Colors.white30
                                : Colors.lightBlueAccent,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              tileColor: Colors.white54,
                              title: Text(
                                quizTypes[index],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: isAdmin
                                  ? Row(
                                mainAxisSize: MainAxisSize.min, // Ensure the row size is minimal
                                children: [
                                  // Edit button
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Navigate to the Edit Video screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizListPage(
                                            groupName: quizTypes[index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                                  : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizPage(
                                      username: authProvider.username,
                                      scienceName: quizTypes[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
    );
  }
}

class QuizListPage extends StatefulWidget {
  final String groupName;

  QuizListPage({required this.groupName});
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  final double containerWidthFraction = 0.95;
  final double containerHeightFraction = 0.95;
  List<Map<String, dynamic>> quizzes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    print(widget.groupName);
    final response = await http.post(
      Uri.parse('https://hbnnarzullayev.pythonanywhere.com/get_quizzes_to_dl'), // Replace with actual API URL
      body: json.encode({'group': widget.groupName, "app_id": 2}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quizzes = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error if necessary
    }
  }

  Future<void> deleteQuiz(int quizId) async {
    final response = await http.post(
      Uri.parse('https://hbnnarzullayev.pythonanywhere.com/delete_quiz'), // Replace with actual API URL
      body: json.encode({'quiz_id': quizId, 'app_id': 2}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        quizzes.removeWhere((quiz) => quiz['id'] == quizId);
      });
    } else {
      // Handle error if necessary
    }
  }

  void showDeleteConfirmationDialog(int quizId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Testni o'chirish"),
          content: Text("Haqiqatdan testni o'chirasizmi?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Yo'q"),
            ),
            TextButton(
              onPressed: () {
                deleteQuiz(quizId);
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: Text("O'chirish", style: TextStyle(color: Colors.redAccent),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("${widget.groupName} savollari")),
      body: Container(
        height:
        MediaQuery.of(context).size.height * containerHeightFraction * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.2,
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : quizzes.isEmpty
            ? Center(child: Text("No quizzes available"))
            : ListView.builder(
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            final quiz = quizzes[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Container(
                color: model.mode == ThemeMode.light
                    ? Colors.white30
                    : Colors.lightBlueAccent,
                child: ListTile(
                  title: Text(quiz['quiz']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDeleteConfirmationDialog(quiz['id']);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AddQuizPage extends StatefulWidget {
  @override
  _AddQuizPageState createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  List<String> quizTypes = [];
  String? selectedTest;
  final TextEditingController _newTestController = TextEditingController();
  int? selectedAnswer;
  bool isNewTest = false;
  final _quizController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  final _answerController = TextEditingController();
  bool _isLoading = false;

  Future<void> fetchQuizType() async {
    try {
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/get_quiz_types'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'app_id': 2,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('quiz_types')) {
          setState(() {
            quizTypes = List<String>.from(data['quiz_types']);
          });
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to fetch quiz types: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz types: $e');
      setState(() {
        quizTypes = [];
      });
    }
  }

  Future<void> addQuiz() async {
    final quiz = _quizController.text;
    final option1 = _option1Controller.text;
    final option2 = _option2Controller.text;
    final option3 = _option3Controller.text;
    final option4 = _option4Controller.text;
    final answer = selectedAnswer?.toString() ?? "";
    final test = isNewTest ? _newTestController.text : selectedTest ?? "";

    if (quiz.isEmpty ||
        option1.isEmpty ||
        option2.isEmpty ||
        option3.isEmpty ||
        option4.isEmpty ||
        answer.isEmpty
        //test.isEmpty
        ) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text("Barcha qatorni to'ldirish majburiy"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/add_quiz'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'quiz': quiz,
          'app_id': 2,
          'test': test,
          'option1': option1,
          'option2': option2,
          'option3': option3,
          'option4': option4,
          'answer': answer,
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Muvaffaqqiyatli"),
            content: Text("Test muvaffaqqiyatli qo'shildi!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Testni qo\'shishda xatolik yuz berdi.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error adding quiz: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text("Xatolik yuz berdi"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuizType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test qo'shish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: selectedTest,
              items: [
                ...quizTypes.map((quizType) {
                  return DropdownMenuItem(
                    value: quizType,
                    child: Text(quizType),
                  );
                }),
                DropdownMenuItem(
                  value: "New",
                  child: Text("Yangi to'plam"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTest = value;
                  isNewTest = value == "New";
                  if (!isNewTest) {
                    _newTestController.clear();
                  }
                });
              },
              decoration: InputDecoration(
                labelText: "Testlar to'plamini tanlang",
                border: OutlineInputBorder(),
              ),
            ),
            // if (isNewTest)
            //   TextField(
            //     controller: _newTestController,
            //     decoration: InputDecoration(labelText: "Yangi test to'plami"),
            //   ),
            SizedBox(height: 16),
            TextField(
              controller: _quizController,
              decoration: InputDecoration(labelText: "Savol"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _option1Controller,
              decoration: InputDecoration(labelText: '1-variant'),
            ),
            TextField(
              controller: _option2Controller,
              decoration: InputDecoration(labelText: '2-variant'),
            ),
            TextField(
              controller: _option3Controller,
              decoration: InputDecoration(labelText: '3-variant'),
            ),
            TextField(
              controller: _option4Controller,
              decoration: InputDecoration(labelText: '4-variant'),
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<int>(
              value: selectedAnswer,
              items: List.generate(4, (index) {
                final value = index + 1;
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.toString()),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                  _answerController.text = value?.toString() ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: "To'g'ri javob",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: addQuiz,
              child: Text("Testni qo'shish"),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String scienceName;
  final String username; // Pass the username

  const QuizPage({
    Key? key,
    required this.username,
    required this.scienceName,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = []; // Placeholder for fetched questions
  List<int?> userAnswers = [];
  List<int> correctAnswers = [];
  int rightAnswers = 0;
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    try {
      print(widget.scienceName);
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/app_get_quiz'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'app_id': 2,
          'science': widget.scienceName,
        }),
      );

      if (response.statusCode == 200) {
        final data = List<Map<String, dynamic>>.from(jsonDecode(response.body));

        setState(() {
          questions = data;
          userAnswers = List.filled(data.length, null);
          correctAnswers = data.map<int>((q) => q['answer'] ?? 0).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch quizzes');
      }
    } catch (e) {
      print('Error fetching quizzes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveScore() async {
    try {
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/api/userscores'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': widget.username,
          'score': rightAnswers,
          'app': 2,
        }),
      );

      if (response.statusCode == 200) {
        print("Score saved successfully");
      } else {
        print("Failed to save score. Status: ${response.statusCode}");
      }
    } catch (error) {
      print("Error saving score: $error");
    }
  }

  void endQuiz() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Testni yakunlash"),
        content: const Text("Yakunlashni isatysizmi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Yo'q"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Ha"),
          ),
        ],
      ),
    );

    if (confirmed) {
      saveScore();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Test natijasi"),
          content: Text("Sizning natijangiz: $rightAnswers ta to'g'ri javoblar"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Test")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Test")),
        body: const Center(child: Text("Savollar mavjud emas")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Test")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                questions.length,
                    (index) => CircleAvatar(
                  radius: 15,
                  backgroundColor: userAnswers[index] == null
                      ? Colors.grey
                      : userAnswers[index] == correctAnswers[index]
                      ? Colors.yellow
                      : Colors.red,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final options = question['options'] ?? [];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ${question['quiz']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(
                            options.length,
                                (optIndex) {
                              return RadioListTile<int>(
                                title: Text(options[optIndex]),
                                value: optIndex + 1,
                                groupValue: userAnswers[index],
                                onChanged: (value) {
                                  if (userAnswers[index] == null) {
                                    setState(() {
                                      userAnswers[index] = value;
                                      if (value == correctAnswers[index]) {
                                        rightAnswers++;
                                      }
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: endQuiz,
              child: const Text("Yakunlash"),
            ),
          ),
        ],
      ),
    );
  }
}

class quiz_list_page extends StatelessWidget {
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
          "Ma'ruza matnlari",
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white),
        ),
      ),
      body: Container(
        height:
        MediaQuery.of(context).size.height * containerHeightFraction * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.2,
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                  ],
                ),
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

class Lek_page extends StatelessWidget {
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
          "Ma'ruza matnlari",
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white),
        ),
      ),
      body: Container(
        height:
        MediaQuery.of(context).size.height * containerHeightFraction * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.2,
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    LectureCard(
                      pdfPath: "assets/Lectures/1-Maruza.pdf",
                      title:
                      "1-ma'ruza. MIKROBIOLOGIYA FANINING PAYDO BO’LISHI VA RIVOJLANISHI",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/2-Maruza.pdf",
                      title:
                      "2-ma'ruza. PROKARIOTLAR MORFOLOGIYASI VA  TUZILISHI",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/3-Maruza.pdf",
                      title:
                      "3-ma'ruza. Viruslarning mikroorganizlar dunyosida tutgan o‘rni",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/4-Maruza.pdf",
                      title:
                      "4-ma'ruza. Bakteriya hujayrasining tuzilishi va morfologiyasi",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/5-Maruza.pdf",
                      title: "5-ma'ruza. Mikroorganizmlarga tashqi muhit omillarning ta’siri ",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/6-Maruza.pdf",
                      title:
                      "6-ma'ruza. Mikroorganizmlarning o’zaro va boshqa organizmlar bilan o’zaro munosabati ",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/7-Maruza.pdf",
                      title:
                      "7-ma'ruza. MIKROORGANIZMLAR METABOLIZM",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/8-Maruza.pdf",
                      title:
                      "8-ma'ruza. Uglerodning tabiatda aylanishida mikroorganizmlarning orni",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/9-Maruza.pdf",
                      title:
                      "9-ma'ruza. Mikroorganizmlarning tuproq hosil bo‘lishida ahamiyati",
                    ),
                    LectureCard(
                      pdfPath: "assets/Lectures/10-Maruza.pdf",
                      title:
                      "10-ma'ruza. Mikroorganizmlarning tuproqda, suv havzalarida va atmosferada taqalishi",
                    ),
                  ],
                ),
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

class Lab_page extends StatelessWidget {
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
          "Amaliy mashg'ulotlar",
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white),
        ),
      ),
      body: Container(
        height:
        MediaQuery.of(context).size.height * containerHeightFraction * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.2,
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    LectureCard(
                      pdfPath: "assets/Labs/1.pdf",
                      title:
                      "1-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/2.pdf",
                      title:
                      "2-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/3.pdf",
                      title:
                      "3-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/4.pdf",
                      title:
                      "4-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/5.pdf",
                      title:
                      "5-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/6.pdf",
                      title:
                      "6-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/7.pdf",
                      title:
                      "7-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/8.pdf",
                      title:
                      "8-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/9.pdf",
                      title:
                      "9-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/10.pdf",
                      title:
                      "10-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/11.pdf",
                      title:
                      "11-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/12.pdf",
                      title:
                      "12-Amaliy mashg'ulot",
                    ),
                    LectureCard(
                      pdfPath: "assets/Labs/13.pdf",
                      title:
                      "13-Amaliy mashg'ulot",
                    ),
                  ],
                ),
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

class YouTubeVideoListScreen extends StatefulWidget {
  const YouTubeVideoListScreen({Key? key}) : super(key: key);

  @override
  _YouTubeVideoListScreenState createState() => _YouTubeVideoListScreenState();
}

class _YouTubeVideoListScreenState extends State<YouTubeVideoListScreen> {
  List<Map<String, String>> videos = [];
  bool isLoading = true;
  bool isAdmin = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context); // Move this here

    // Now it's safe to access Provider
    fetchVideos(authProvider.username);
  }

  // Fetch video list from Flask API
  Future<void> fetchVideos(String username) async {
    final apiUrl = 'https://hbnnarzullayev.pythonanywhere.com/get_videos?username=$username&app_id=2';  // Correct URL with query parameters

    try {
      final response = await http.get(Uri.parse(apiUrl));  // No need to set headers for username here

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> videoData = responseData['videos'];
        setState(() {
          videos = videoData.map((video) {
            return {
              'name': video['name'] as String,
              'url': video['url'] as String,
            };
          }).toList();

          var isAdminValue = responseData['is_admin'];
          isAdmin = (isAdminValue is bool) ? isAdminValue : (isAdminValue == 'true');
          isLoading = false;
        });
      } else {
        throw Exception('Video darsni yuklashda xatolik');
      }
    } catch (e) {
      print('Error fetching videos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to handle video deletion
  void deleteVideo(String videourl) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // Get the provider safely
    print("Deleting video with URL: $videourl");

    try {
      final response = await http.delete(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/delete_video'),
        headers: {'Content-Type': 'application/json'},  // Ensure the content type is set to JSON
        body: jsonEncode({'video_url': videourl}),  // Send video_url in the body
      );

      if (response.statusCode == 200) {
        fetchVideos(authProvider.username);
        print('Video deleted successfully');
      } else {
        print('Failed to delete video: ${response.body}');
      }
    } catch (e) {
      print('Error deleting video: $e');
    }
  }

  // Function to show confirmation dialog before deleting video
  void _showDeleteConfirmation(String videourl) {
    print(videourl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Video darsni o'chirish"),
        content: Text("Video darsni o'chirasizmi"),
        actions: [
          TextButton(
            onPressed: () {
              deleteVideo(videourl);
              print(videourl);
              Navigator.pop(context);
            },
            child: Text('Ha', style: TextStyle(color: Colors.redAccent),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Yo'q", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video darsliklar'),
        actions: [
          // Only show the Add Video button if the user is an admin
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Navigate to the Add Video screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVideoPage(), // Navigate to the Add Video page
                  ),
                );
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(5),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Padding(
            padding: EdgeInsets.only(top:5),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              tileColor: Colors.white30,
              focusColor: Colors.white,
              leading: const Icon(Icons.play_circle_filled),
              title: Text(video['name']!),
              subtitle: Text(video['url']!),
              trailing: isAdmin
                  ? Row(
                mainAxisSize: MainAxisSize.min, // Ensure the row size is minimal
                children: [
                  // Edit button
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to the Edit Video screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditVideoScreen(
                            currentName: video['name']!,
                            currentUrl: video['url']!,
                          ),
                        ),
                      );
                    },
                  ),
                  // Delete button
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmation(video['url']!); // Show confirmation dialog
                    },
                  ),
                ],
              )
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YouTubeScreen(
                      videoUrl: video['url']!,
                      name: video['name']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EditVideoScreen extends StatefulWidget {
  final String currentName;
  final String currentUrl;

  EditVideoScreen({
    required this.currentName,
    required this.currentUrl,
  });

  @override
  _EditVideoScreenState createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String videoName;
  late String videoUrl;

  @override
  void initState() {
    super.initState();
    videoName = widget.currentName;
    videoUrl = widget.currentUrl;
  }

  // Function to edit the video
  Future<void> editVideo() async {

    // Now it's safe to access Provider
    const apiUrl = 'https://hbnnarzullayev.pythonanywhere.com/edit_video';
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': videoName,
        'url': videoUrl,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video muvaffaqqiyatli tahrirlandi')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tahrirlashda xatolik(tekshiring)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video darsni tahrirlash')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: videoName,
                decoration: InputDecoration(labelText: 'Video nomi'),
                onChanged: (value) {
                  setState(() {
                    videoName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos video nomini kiriting';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: videoUrl,
                decoration: InputDecoration(labelText: "Video URL(to'liq)"),
                onChanged: (value) {
                  setState(() {
                    videoUrl = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos URLni kiriting';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    editVideo();
                  }
                },
                child: Text('Videoni tahrirlash'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddVideoPage extends StatefulWidget {
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _videoUrlController = TextEditingController();
  final _videoNameController = TextEditingController();
  bool _isLoading = false;

  Future<void> addVideo() async {
    final videoUrl = _videoUrlController.text;
    final videoName = _videoNameController.text;

    if (videoUrl.isEmpty || videoName.isEmpty) {
      // Show error message if any field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text("Ikala qatorni to'ldirish majburiy"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your actual Flask app URL
      final response = await http.post(
        Uri.parse('https://hbnnarzullayev.pythonanywhere.com/add_video'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'video_url': videoUrl,
          'app_id': 2,
          'name': videoName,
        }),
      );

      if (response.statusCode == 200) {
        // Success, show a message or navigate
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Video muvaffaqqiyatli saqlandi!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Go back to previous screen
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Error occurred
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Videoni saqlashda xatolik.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
      // Show error if any exception occurs
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Xatolik yuz berdi'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video dars qo'shish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _videoUrlController,
              decoration: InputDecoration(labelText: "Video URL(to'liq)"),
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _videoNameController,
              decoration: InputDecoration(labelText: 'Video dars nomi'),
            ),
            SizedBox(height: 32),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: addVideo,
              child: Text("Video dars qo'shish"),
            ),
          ],
        ),
      ),
    );
  }
}

class Ppt_page extends StatelessWidget {
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
          "Taqdimotlar",
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white),
        ),
      ),
      body: Container(
        height:
        MediaQuery.of(context).size.height * containerHeightFraction * 1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.2,
            image: AssetImage(
                'assets/images/back.jpg'), // Replace with your image asset path
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    PPTCard(
                      pdfPath: "assets/PPTLab/Bakteriya hujayrasining tuzilishi o'lchamlari+.pdf",
                      title: "Bakteriya hujayrasining tuzilishi o'lchamlari",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Bakteriyalar.pdf",
                      title: "Bakteriyalar",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Bakteriya o'lchamlari va morfologiyasi+.pdf",
                      title:
                      "Bakteriya o'lchamlari va morfologiyasi",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Mikrobiologiya fanining tarixi.pdf",
                      title: "Mikrobiologiya fanining tarixi",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Mikroorganizmlarda moddalar almashinuvi.pdf",
                      title:
                      "Mikroorganizmlarda moddalar almashinuvi",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/MIKROORGANIZMLARGA TASHQI MUHIT OMILLARNING TA’SIRI.pdf",
                      title:
                      "MIKROORGANIZMLARGA TASHQI MUHIT OMILLARNING TA’SIRI",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Mikroorganizmlar hayotida viruslarning o'rni+.pdf",
                      title: "Mikroorganizmlar hayotida viruslarning o'rni",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/MIKROORGANIZMLAR METABOLIZMi.pdf",
                      title: "MIKROORGANIZMLAR METABOLIZMi",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Mikroorganizmlarning_morfologiyasi_tuzilishi,_ko'payishi_va_klassifikatsiyasi.pdf",
                      title: "Mikroorganizmlarning_morfologiyasi_tuzilishi,_ko'payishi_va_klassifikatsiyasi",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/MIKROORGANIZMLARNING_TUPROQDA,_SUV_HAVZALARIDA_VA_ATMOSFERADA_TAQALISHI.pdf",
                      title: "MIKROORGANIZMLARNING_TUPROQDA,_SUV_HAVZALARIDA_VA_ATMOSFERADA_TAQALISHI",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/MIKROORGANIZMLARNING_TUPROQDA,_SUV_HAVZALARIDA_VA_ATMOSFERADA_TAQALISHI.pdf",
                      title:
                      "MIKROORGANIZMLARNING_TUPROQDA,_SUV_HAVZALARIDA_VA_ATMOSFERADA_TAQALISHI",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Mikroorganizmlarning o'zaro munosabatlari.pdf",
                      title: "Mikroorganizmlarning o'zaro munosabatlari",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/mikroorganizm tuproq hosil bo'lishidagi ahamiyati.pdf",
                      title:
                      "mikroorganizm tuproq hosil bo'lishidagi ahamiyati",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/Uglerodning tabiatda almashinuvida mikrorganizmlarning roli.pdf",
                      title:
                      "Uglerodning tabiatda almashinuvida mikrorganizmlarning roli",
                    ),
                    PPTCard(
                      pdfPath: "assets/PPTLab/uglerodning tabiatda aylanishida mikroorganizmlar roli.pdf",
                      title: "uglerodning tabiatda aylanishida mikroorganizmlar roli",
                    ),
                  ],
                ),
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
        title: Text(
          "O'qilmoqda",
          style: TextStyle(
              color: model.mode == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.white),
        ),
        actions: [
          if (_isReady)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${_currentPage + 1}/$_totalPages',
                  style: TextStyle(
                      color: model.mode == ThemeMode.light
                          ? Colors.blueAccent
                          : Colors.white),
                ),
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
