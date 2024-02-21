import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final String? userId;
  final String? name;
  final String? email;
  final String? image;
  final List<String>? roles;
  final String? accessToken;

  LoginResponse({
    this.userId,
    this.name,
    this.email,
    this.image,
    this.roles,
    this.accessToken
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userId: json["userId"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
    roles: json["roles"] != null ? List<String>.from(json["roles"].map((x) => x)) : null,
    accessToken: json["accessToken"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "email": email,
    "image": image,
    "roles": roles,
    "accessToken": accessToken,
  };
}

