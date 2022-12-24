class LoginResponseModel {
  String token;
  String refreshToken;
  DateTime create;
  DateTime expiration;
  DateTime refreshExpiration;

  LoginResponseModel(this.token, this.refreshToken, this.create, this.expiration, this.refreshExpiration);

  LoginResponseModel.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        refreshToken = json['refreshToken'],
        create = DateTime.parse(json['create']),
        expiration = DateTime.parse(json['expiration']),
        refreshExpiration = DateTime.parse(json['refreshExpiration']);

  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
        'create': create,
        'expiration': expiration,
        'refreshExpiration': refreshExpiration,
      };
}
