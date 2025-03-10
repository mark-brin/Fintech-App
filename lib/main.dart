import 'package:fintech_app/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintech_app/state/appstate.dart';
//import 'package:fintech_app/auth/onboarding.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      child: FintechApp(),
    ),
  );
}

class FintechApp extends StatefulWidget {
  const FintechApp({super.key});
  @override
  State<FintechApp> createState() => _FintechAppState();
}

class _FintechAppState extends State<FintechApp> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp.router(
      title: 'Fintech App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      //home: Scaffold(body: DashBoard()),
      // home: Scaffold(body: OnboardingPage()),
      //theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
