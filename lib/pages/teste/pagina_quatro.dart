import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste/providers/auth_provider.dart';

class PaginaQuatro extends StatefulWidget {
  const PaginaQuatro({super.key});

  @override
  State<PaginaQuatro> createState() => _PaginaQuatroState();
}

class _PaginaQuatroState extends State<PaginaQuatro> {
  bool _processando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página quatro')),
      body: _page(),
    );
  }

  Widget _page() {
    return Consumer<AuthProvider>(
      builder: (context, value, child) => SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("isProcessing: ${value.isProcessing.toString()}"),
            Text("isAuthenticated: ${value.isAuthenticated.toString()}"),
            Text("create: ${value.auth?.create.toString()}"),
            Text("expiration: ${value.auth?.expiration.toString()}"),
            Text(_textoVencimento(value.auth?.expiration ?? DateTime.now())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processando || value.isProcessing ? null : _refreshToken,
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }

  String _textoVencimento(DateTime expiration) {
    return DateTime.now().isAfter(expiration)
        ? "vencido: ${(DateTime.now().difference(expiration))}"
        : "OK: ${(expiration.difference(DateTime.now()))}";
  }

  void _refreshToken() {
    setState(() {
      _processando = true;
    });

    Provider.of<AuthProvider>(context, listen: false).refreshToken().then(
      (value) {
        if (!mounted) return;

        setState(() {
          _processando = false;
        });
      },
    );
  }
}
