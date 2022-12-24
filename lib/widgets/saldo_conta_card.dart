import 'package:flutter/material.dart';
import 'package:teste/models/saldo_conta_model.dart';

class SaldoContaCard extends StatelessWidget {
  final SaldoContaModel saldoConta;

  const SaldoContaCard(this.saldoConta, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.car_repair),
              title: Text(saldoConta.contaBancaria),
              subtitle: Text("${saldoConta.data} ${saldoConta.valorSaldo}"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
