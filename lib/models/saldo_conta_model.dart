class SaldoContaModel {
  int id;
  int contaBancariaId;
  String contaBancaria;
  String data;
  double valorMovimentacoes;
  double valorSaldo;

  SaldoContaModel(this.id, this.contaBancariaId, this.contaBancaria, this.data, this.valorMovimentacoes, this.valorSaldo);

  SaldoContaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        contaBancariaId = json['contaBancariaId'],
        contaBancaria = json['contaBancaria'],
        data = json['data'],
        valorMovimentacoes = json['valorMovimentacoes'],
        valorSaldo = json['valorSaldo'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'contaBancariaId': contaBancariaId,
        'contaBancaria': contaBancaria,
        'data': data,
        'valorMovimentacoes': valorMovimentacoes,
        'valorSaldo': valorSaldo,
      };
}
