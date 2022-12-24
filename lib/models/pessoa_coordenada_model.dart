class PessoaCoordenadaModel {
  int id;
  int pessoaId;
  String pessoaNome;
  String? ultimaDescricaoDespesa;
  int? contaBancariaId;
  int? cartaoCreditoId;
  double latitude;
  double longitude;
  double distancia;

  PessoaCoordenadaModel(this.id, this.pessoaId, this.pessoaNome, this.ultimaDescricaoDespesa, this.contaBancariaId, this.cartaoCreditoId,
      this.latitude, this.longitude, this.distancia);

  PessoaCoordenadaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pessoaId = json['pessoaId'],
        pessoaNome = json['pessoaNome'],
        ultimaDescricaoDespesa = json['ultimaDescricaoDespesa'],
        contaBancariaId = json['contaBancariaId'],
        cartaoCreditoId = json['cartaoCreditoId'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        distancia = json['distancia'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'pessoaId': pessoaId,
        'pessoaNome': pessoaNome,
        'ultimaDescricaoDespesa': ultimaDescricaoDespesa,
        'contaBancariaId': contaBancariaId,
        'cartaoCreditoId': cartaoCreditoId,
        'latitude': latitude,
        'longitude': longitude,
        'distancia': distancia,
      };
}
