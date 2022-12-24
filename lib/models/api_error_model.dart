class ApiErrorModel {
  String? message;

  ApiErrorModel({this.message});

  ApiErrorModel.fromJson(Map<String, dynamic> json) : message = json['message'];

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
