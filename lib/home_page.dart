import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:teste/pages/teste/pagina_dois.dart';
import 'package:teste/pages/teste/pagina_quatro.dart';
import 'package:teste/pages/teste/pagina_tres.dart';
import 'package:teste/providers/auth_provider.dart';
import 'package:teste/widgets/app_drawer.dart';

GetIt getIt = GetIt.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home page')),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const Text('It worked!!'),
          ElevatedButton(onPressed: onPressed, child: const Text('Logout')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _abrirPagina(context, const PaginaDois()),
                child: const Text("Página 2"),
              ),
              ElevatedButton(
                onPressed: () => _abrirPagina(context, const PaginaTres()),
                child: const Text("Página 3"),
              ),
              ElevatedButton(
                onPressed: () => _abrirPagina(context, const PaginaQuatro()),
                child: const Text("Página 4"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onPressed() async {
    Provider.of<AuthProvider>(context, listen: false).logout();

    //await getIt<AuthService>().clear();
    //if (!mounted) return;
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LandingPage()));
  }

  Future _abrirPagina(BuildContext context, Widget pagina) {
    return Navigator.push(context, MaterialPageRoute(builder: (BuildContext cx) => pagina));
  }
}
