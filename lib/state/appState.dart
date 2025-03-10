import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class AppState extends ChangeNotifier {
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      notifyListeners();
    }
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  // ignore: prefer_final_fields
  PageController _pageController = PageController();
  PageController get pageController => _pageController;

  set setPageIndex(int index) {
    _pageIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  /// Constructor (load theme from shared preferences)
  AppState() {
    _loadTheme();
  }

  /// Load Dark Mode from Shared Preferences
  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  /// Toggle Dark Mode and Persist it
  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
