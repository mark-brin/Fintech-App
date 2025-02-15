import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintech_app/state/appState.dart';
import 'package:fintech_app/dashboard/dashboard.dart';

void main() {
  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      child: MaterialApp(
        title: 'Fintech App',
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: DashBoard()),
        //home: Scaffold(body: OnboardingPage()),
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
