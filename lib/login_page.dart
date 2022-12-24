import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:teste/home_page.dart';
import 'package:teste/models/login/login_request_model.dart';
import 'package:teste/providers/auth_provider.dart';
import 'package:teste/services/api/mangos_api_service.dart';

GetIt getIt = GetIt.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _globalKey = GlobalKey<FormState>();
  final _request = LoginRequestModel();

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('E-mail'),
                  hintText: 'seu@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _request.email = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'O e-mail deve ser informado';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Senha'),
                  hintText: '',
                ),
                obscureText: true,
                onSaved: (value) => _request.senha = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'A senha deve ser informada';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 25),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : logar,
                  icon: _isLoading
                      ? Container(
                          width: 16,
                          height: 16,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.login, size: 16),
                  label: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logar() async {
    setState(() {
      _isLoading = true;
    });

    FocusManager.instance.primaryFocus?.unfocus();

    if (_globalKey.currentState?.validate() ?? false) {
      _globalKey.currentState?.save();

      var provider = Provider.of<AuthProvider>(context, listen: false);

      if (await provider.login(_request)) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login moiô"),
        ));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
