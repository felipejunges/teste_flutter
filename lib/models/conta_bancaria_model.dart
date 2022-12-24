class ContaBancariaModel {
  int id;
  String descricao;

  ContaBancariaModel(this.id, this.descricao);

  ContaBancariaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        descricao = json['descricao'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
      };
}
