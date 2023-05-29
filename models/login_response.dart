import 'User.dart';

class LoginResponse {
  User? user;
  String? accessToken;
  String? status;
  String? message;
  LoginResponse({
      required this.user,
      required this.accessToken,
      required this.status,
      required this.message
   });

  LoginResponse.fromJson(dynamic json) {

    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    status = json['status'];
    message = json['message'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user!.toJson();
    }
    map['access_token'] = accessToken;
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}