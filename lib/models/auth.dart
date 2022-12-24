class Auth {
  DateTime create;
  DateTime expiration;
  String token;
  String refreshToken;

  Auth(this.create, this.expiration, this.token, this.refreshToken);

  Auth.fromJson(Map<String, dynamic> json)
      : create = DateTime.parse(json['create']),
        expiration = DateTime.parse(json['expiration']),
        token = json['token'],
        refreshToken = json['refreshToken'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create'] = this.create;
    data['expiration'] = this.expiration;
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}
