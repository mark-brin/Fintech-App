import "package:flutter/material.dart";

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
}
