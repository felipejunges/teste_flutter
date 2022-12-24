class CartaoCreditoModel {
  int id;
  String descricao;

  CartaoCreditoModel(this.id, this.descricao);

  CartaoCreditoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        descricao = json['descricao'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
      };
}
