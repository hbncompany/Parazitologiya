import 'package:flutter/material.dart';
import 'StorageManager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    // backgroundColor: const Color(0xFF212121),
    backgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white, // Set the desired background color here
    ),
    primarySwatch: Colors.teal,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: Colors.white54,
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.black,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  ThemeData _themeData = ThemeData.light();
  ThemeData get getTheme => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}