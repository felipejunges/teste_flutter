class DespesaRapidaModel {
  int? pessoaId;
  String? descricao;
  double? valor;
  String? contaBancariaId;
  String? cartaoCreditoId;

  DespesaRapidaModel({this.pessoaId, this.descricao, this.valor, this.contaBancariaId, this.cartaoCreditoId});

  Map<String, dynamic> toJson() => {
        'pessoaId': pessoaId,
        'descricao': descricao,
        'valor': valor,
        'contaBancariaId': contaBancariaId,
        'cartaoCreditoId': cartaoCreditoId,
      };
}
