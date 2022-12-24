import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste/home_page.dart';
import 'package:teste/login_page.dart';
import 'package:teste/services/api/auth_service.dart';

GetIt getIt = GetIt.instance;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _loadUserInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  _loadUserInfo(context) async {
    var token = await getIt<AuthService>().get();

    if (token == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
