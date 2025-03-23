import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintech_app/common/splash.dart';
import 'package:fintech_app/state/appstate.dart';

void main() {
  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        //ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
      ],
      child: MaterialApp(
        title: 'Fintech App',
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: SplashPage()),
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
