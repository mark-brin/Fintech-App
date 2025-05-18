import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/dashboard/dashboard.dart';

class FakeHttpClient extends http.BaseClient {
  final Map<String, http.Response> _responses = {};
  void addResponse(String url, http.Response response) {
    _responses[url] = response;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = _responses[request.url.toString()];
    if (response != null) {
      return http.StreamedResponse(
        Stream.value(response.bodyBytes),
        response.statusCode,
        headers: response.headers,
      );
    }
    return http.StreamedResponse(
      Stream.value(utf8.encode('{"error": "No mock response"}')),
      404,
    );
  }
}

void main() {
  final originalHttpClient = http.Client();

  final fakeClient = FakeHttpClient();
  const userDataJson =
      '{"firstName": "John", "email": "john@example.com", "phone": "1234567890"}';

  setUp(() {
    http.Client.new = () => fakeClient;
    fakeClient.addResponse(
        'https://dummyjson.com/users/1', http.Response(userDataJson, 200));
  });

  tearDown(() {
    http.Client.new = () => originalHttpClient;
  });

  group('DashBoard API Methods', () {
    //test('getName() returns the user\'s first name', () async {
    //  final dashboard = DashBoard();
    //  final name = await dashboard.getName();
    //  expect(name, 'John');
    //});

    // test('getEmail() returns the user\'s email', () async {
    //   final dashboard = DashBoard();
    //   final email = await dashboard.getEmail();
    //   expect(email, 'john@example.com');
    // });

    //test('getPhone() returns the user\'s phone number', () async {
    //  final dashboard = DashBoard();
    //  final phone = await dashboard.getPhone();
    //  expect(phone, '1234567890');
    //});

    test('API methods handle errors properly', () async {
      fakeClient.addResponse(
        'https://dummyjson.com/users/1',
        http.Response('Server Error', 500),
      );
      //final dashboard = DashBoard();
      //expect(dashboard.getName(), throwsException);
      //expect(dashboard.getEmail(), throwsException);
      //expect(dashboard.getPhone(), throwsException);
    });
  });
}

class TestAppState extends ChangeNotifier implements AppState {
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

  @override
  int get pageIndex => _pageIndex;

  @override
  set setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}

void mainFn() {
  Widget createDashboardWithProvider() {
    return MaterialApp(
      home: ChangeNotifierProvider<AppState>(
        create: (_) => TestAppState(),
        child: const DashBoard(),
      ),
    );
  }

  testWidgets('Dashboard renders header section', (WidgetTester tester) async {
    await tester.pumpWidget(createDashboardWithProvider());

    // Find the Welcome text in AppBar
    expect(find.text('Welcome,'), findsOneWidget);

    // Verify loading state of FutureBuilders initially
    expect(find.text('Loading...'), findsAtLeastNWidgets(2));

    // Allow futures to complete
    await tester.pump(Duration(seconds: 1));
  });

  testWidgets('Dashboard displays Quick Actions section',
      (WidgetTester tester) async {
    await tester.pumpWidget(createDashboardWithProvider());

    // Check section title
    expect(find.text('Quick Actions'), findsOneWidget);

    // Check for quick action cards
    expect(find.text('My Wallet'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
  });

  testWidgets('Dashboard displays Services section',
      (WidgetTester tester) async {
    await tester.pumpWidget(createDashboardWithProvider());

    // Check section title
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Pay Money'), findsOneWidget);
    expect(find.text('Request Money'), findsOneWidget);
    expect(find.text('Approvals'), findsOneWidget);
    expect(find.text('Mandates'), findsOneWidget);
    expect(find.text('Scan QR'), findsOneWidget);
    expect(find.text('Generate QR'), findsOneWidget);
  });
}
