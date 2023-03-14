import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:teste/home_page.dart';
import 'package:teste/login_page.dart';
import 'package:teste/providers/auth_provider.dart';
import 'package:teste/services/api/mangos_api_service.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<MangosApiService>(MangosApiService(), signalsReady: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer(
          builder: (BuildContext context, AuthProvider auth, Widget? child) {
            return auth.isAuthenticated ? const HomePage() : const LoginPage();
          },
        ),
      ),
    );
  }
}
