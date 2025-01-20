import 'package:flutter/material.dart';
import 'package:fintech_app/onboarding/onboarding.dart';

void main() {
  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OnboardingPage());
  }
}
