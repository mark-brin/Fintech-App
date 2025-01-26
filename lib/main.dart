import 'package:flutter/material.dart';
import 'package:fintech_app/profile/profile.dart';

void main() {
  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: ProfilePage()),
    );
  } //TODO: Change to onboarding
}
