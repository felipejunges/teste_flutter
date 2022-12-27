import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teste/models/saldo_conta_model.dart';
import 'package:teste/services/api/mangos_api_service.dart';
import 'package:teste/widgets/saldo_conta_card.dart';

GetIt getIt = GetIt.instance;

class PaginaDois extends StatefulWidget {
  const PaginaDois({super.key});

  @override
  State<PaginaDois> createState() => _PaginaDoisState();
}

class _PaginaDoisState extends State<PaginaDois> {
  late Future<List<SaldoContaModel>> _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página dois')),
      body: _page(),
    );
  }

  @override
  void initState() {
    super.initState();

    _atualizarFuture();
  }

  void _atualizarFuture() {
    setState(() {
      _future = getIt<MangosApiService>().getSaldosConta();
    });
  }

  Widget _page() {
    return Column(
      children: [
        ElevatedButton(onPressed: () => _atualizarFuture(), child: const Text('Buscar')),
        Expanded(child: _novoBody()),
      ],
    );
  }

  Widget _novoBody() {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<SaldoContaModel>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.error != null) {
          return const Center(child: Text("Ih, deu boxta merrmão"));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Terminou, mas veio vazio :("));
        }

        return _itens(snapshot.data);
      },
    );
  }

  Widget _itens(itens) {
    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () => {
          _tapItem(context),
        },
        child: SaldoContaCard(itens[index]),
      ),
    );
  }

  _tapItem(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _tapAppBar(context) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Flutter é topzera"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.pop(context),
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}
