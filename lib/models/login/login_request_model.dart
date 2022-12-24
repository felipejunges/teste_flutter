class LoginRequestModel {
  String? email;
  String? senha;

  LoginRequestModel({this.email, this.senha});

  LoginRequestModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        senha = json['senha'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'senha': senha,
      };
}
