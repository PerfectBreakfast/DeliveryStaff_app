import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) => ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {

  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final String? code;
  final String? phoneNumber;
  final bool? emailConfirmed;
  final bool? lockoutEnabled;
  final String? companyName;
  final List<String>? roles;


  ProfileResponse({
    this.id,
    this.name,
    this.email,
    this.image,
    this.code,
    this.phoneNumber,
    this.emailConfirmed,
    this.lockoutEnabled,
    this.companyName,
    this.roles
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
    code: json["code"],
    phoneNumber: json["phoneNumber"],
    emailConfirmed: json["emailConfirmed"],
    lockoutEnabled: json["lockoutEnabled"],
    companyName: json["companyName"],
      roles: json["roles"] != null ? List<String>.from(json["roles"].map((x) => x)) : null
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "image": image,
    "code": code,
    "phoneNumber": phoneNumber,
    "emailConfirmed": emailConfirmed,
    "lockoutEnabled": lockoutEnabled,
    "companyName": companyName,
    "roles": roles,
  };
}