import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:teste/models/despesa_rapida_model.dart';
import 'package:teste/services/api/mangos_api_service.dart';

GetIt getIt = GetIt.instance;

class PaginaTres extends StatefulWidget {
  const PaginaTres({super.key});

  @override
  State<PaginaTres> createState() => _PaginaTresState();
}

class _PaginaTresState extends State<PaginaTres> {
  final _globalKey = GlobalKey<FormState>();
  final _model = DespesaRapidaModel();

  List<DropdownMenuItem<String>> _itensContas = [];
  List<DropdownMenuItem<String>> _itensCartoes = [];

  final _pessoaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = MoneyMaskedTextController(initialValue: 0);

  bool processandoGps = false;
  bool incluindoDespesa = false;

  @override
  void initState() {
    super.initState();

    Future.wait([_obterContasBancarias(), _obterCartoesCredito()]).then(
      (value) => _obterPessoaMaisProxima(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página três')),
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: processandoGps ? null : _obterPessoaMaisProxima,
                icon: processandoGps
                    ? Container(
                        width: 16,
                        height: 16,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.gps_fixed, size: 16),
                label: const Text('GPS'),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Pessoa'),
                ),
                controller: _pessoaController,
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Descrição'),
                ),
                onSaved: (value) => _model.descricao = value,
                controller: _descricaoController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'A descrição deve ser informada';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Valor'),
                ),
                controller: _valorController,
                onSaved: (value) => _model.valor = double.parse(value?.replaceAll(',', '.') ?? "0"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  label: Text('Conta bancária'),
                ),
                hint: const Text('Conta bancária'),
                items: _itensContas,
                value: _model.contaBancariaId,
                onChanged: onContaBancariaChanged,
                isExpanded: true,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  label: Text('Cartão de crédito'),
                ),
                hint: const Text('Cartão de crédito'),
                items: _itensCartoes,
                value: _model.cartaoCreditoId,
                onChanged: onCartaoCreditoChanged,
                isExpanded: true,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 25),
                child: ElevatedButton(
                  onPressed: processandoGps || incluindoDespesa ? null : _incluirDespesaRapida,
                  child: const Text('Go!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _incluirDespesaRapida() async {
    _globalKey.currentState?.save();

    if (_globalKey.currentState?.validate() ?? false) {
      setState(() {
        incluindoDespesa = true;
      });

      if (await getIt<MangosApiService>().incluirDespesaRapida(_model)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Despesa incluída com sucesso!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao incluir despesa rápida...")));
      }

      setState(() {
        incluindoDespesa = false;
      });
    }
  }

  Future _obterContasBancarias() async {
    var contasBancarias = await getIt<MangosApiService>().getContasBancarias();

    setState(() {
      _itensContas = contasBancarias
          .map((e) => DropdownMenuItem<String>(
                value: e.id.toString(),
                child: Text(e.descricao),
              ))
          .toList();
    });
  }

  Future _obterCartoesCredito() async {
    var cartoesCredito = await getIt<MangosApiService>().getCartoesCredito();

    setState(() {
      _itensCartoes = cartoesCredito
          .map((e) => DropdownMenuItem<String>(
                value: e.id.toString(),
                child: Text(e.descricao),
              ))
          .toList();
    });
  }

  onContaBancariaChanged(value) {
    setState(() {
      _model.contaBancariaId = value;
    });
  }

  onCartaoCreditoChanged(value) {
    setState(() {
      _model.cartaoCreditoId = value;
    });
  }

  _obterPessoaMaisProxima() async {
    debugPrint('Obtendo pessoa mais próxima');

    setState(() {
      processandoGps = true;
    });

    var position = _determinePosition();

    position
        .then(
          (value) => _handleGotPosition(value),
        )
        .onError(
          (error, stackTrace) => {
            debugPrint("Deu bosta no GPS: $error"),
          },
        );
  }

  _handleGotPosition(Position position) async {
    var pessoaCoordenada = await getIt<MangosApiService>().getPessoaCoordenada(position.latitude, position.longitude);

    if (pessoaCoordenada == null) return;

    _pessoaController.text = pessoaCoordenada.pessoaNome;
    _descricaoController.text = pessoaCoordenada.ultimaDescricaoDespesa ?? "";

    setState(() {
      processandoGps = false;

      _model.pessoaId = pessoaCoordenada.pessoaId;
      _model.descricao = pessoaCoordenada.ultimaDescricaoDespesa;

      if (pessoaCoordenada.contaBancariaId != null && _itensContas.any((e) => e.value == pessoaCoordenada.contaBancariaId?.toString())) {
        _model.contaBancariaId = pessoaCoordenada.contaBancariaId?.toString();
      } else {
        _model.contaBancariaId = null;
      }

      if (pessoaCoordenada.cartaoCreditoId != null && _itensCartoes.any((e) => e.value == pessoaCoordenada.cartaoCreditoId?.toString())) {
        _model.cartaoCreditoId = pessoaCoordenada.cartaoCreditoId?.toString();
      } else {
        _model.cartaoCreditoId = null;
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  }
}
