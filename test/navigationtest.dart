import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/dashboard/dashboard.dart';

class NavigationTestAppState extends ChangeNotifier implements AppState {
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      notifyListeners();
    }
  }

  final PageController pageController = PageController();
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  set setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}

void main() {
  late NavigationTestAppState testAppState;

  Widget createDashboard() {
    return MaterialApp(
      home: ChangeNotifierProvider<AppState>.value(
        value: testAppState,
        child: DashBoard(),
      ),
    );
  }

  setUp(() {
    testAppState = NavigationTestAppState();
  });

  group('Dashboard Navigation Tests', () {
    testWidgets('Tapping My Wallet navigates to wallet page',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDashboard());

      // Find and tap the My Wallet card
      await tester.tap(find.text('My Wallet'));
      await tester.pump();

      // Verify page index is updated to wallet page
      expect(testAppState.pageIndex, 1);
    });

    testWidgets('Tapping Transactions navigates to transactions page',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDashboard());

      // Find and tap the Transactions card
      await tester.tap(find.text('Transactions'));
      await tester.pump();

      // Verify page index is updated to transactions page
      expect(testAppState.pageIndex, 3);
    });

    testWidgets('Tapping Pay Money service navigates to pay money page',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDashboard());

      // Find and tap the Pay Money service
      await tester.tap(find.text('Pay Money'));
      await tester.pump();

      // Verify page index is updated to pay money page
      expect(testAppState.pageIndex, 5);
    });

    testWidgets('Tapping Scan QR navigates to scan QR page',
        (WidgetTester tester) async {
      await tester.pumpWidget(createDashboard());

      // Find and tap the Scan QR service
      await tester.tap(find.text('Scan QR'));
      await tester.pump();

      // Verify page index is updated to scan QR page
      expect(testAppState.pageIndex, 9);
    });
  });
}
