import 'dart:convert';

BaseResponse baseResponseFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

class BaseResponse {

  final int? statusCode;
  final String? statusPhrase;
  final dynamic errors;
  final String? timestamp;

  BaseResponse(
      {this.statusCode, this.statusPhrase, this.errors, this.timestamp});

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        statusCode: json["statusCode"],
        statusPhrase: json["statusPhrase"],
        errors: json["errors"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "statusPhrase": statusPhrase,
        "errors": errors,
        "timestamp": timestamp,
      };
}
