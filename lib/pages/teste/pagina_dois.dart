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
  List<SaldoContaModel> _saldosConta = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página dois')),
      body: _page(),
    );
  }

  _page() {
    return Column(
      children: [
        ElevatedButton(onPressed: _buscarItens, child: const Text('Buscar')),
        Expanded(child: _itens()),
      ],
    );
  }

  _buscarItens() async {
    var saldosConta = await getIt<MangosApiService>().getSaldosConta();

    setState(() {
      _saldosConta = saldosConta;
    });
  }

  _itens() {
    return ListView.builder(
      itemCount: _saldosConta.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () => {
          _tapItem(context),
        },
        child: SaldoContaCard(_saldosConta[index]),
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
