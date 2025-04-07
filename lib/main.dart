import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintech_app/common/splash.dart';
import 'package:fintech_app/state/appstate.dart';
import 'package:fintech_app/state/authstate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
    url: 'https://jzdemhpriayzrmxznnkl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6ZGVtaHByaWF5enJteHpubmtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0OTQ2NjAsImV4cCI6MjA1OTA3MDY2MH0.wJGaGCgqsEf-UaWutlbcxTxU5RWEhGARb67QKjxT6pA',
  );
  runApp(const FintechApp());
}

class FintechApp extends StatelessWidget {
  const FintechApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthenticationState>(
            create: (_) => AuthenticationState()),
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
