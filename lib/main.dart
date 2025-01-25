import 'package:flutter/material.dart';
import 'package:fintech_app/dashboard/dashboard.dart';

void main() {
  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech App',
      home: Scaffold(body: DashBoard()), //TODO: Change this to onboarding
      debugShowCheckedModeBanner: false,
    );
  }
}
