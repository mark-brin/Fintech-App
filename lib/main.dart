import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearpay/common/splash.dart';
import 'package:clearpay/common/locator.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:clearpay/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clearpay/state/requestState.dart';
import 'package:clearpay/state/transactionState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupDependencies();
  runApp(const ClearPay());
}

class ClearPay extends StatelessWidget {
  const ClearPay({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<RequestsState>(create: (_) => RequestsState()),
        ChangeNotifierProvider<TransactionState>(
          create: (_) => TransactionState(),
        ),
      ],
      child: MaterialApp(
        title: 'ClearPay',
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: SplashPage()),
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
