
import 'dart:convert';

import 'package:flutter/material.dart';

OrderDetailResponse slotsResponseFromJson(String str) => OrderDetailResponse.fromJson(json.decode(str));

String slotsResponseToJson(OrderDetailResponse data) => json.encode(data.toJson());

class OrderDetailResponse {
  final String? id;
  final String? note;
  final double? totalPrice;
  final String? orderStatus;
  final int? orderCode;
  final String? paymentMethod;
  final DateTime? creationDate;
  final DateTime? bookingDate;
  final List<OrderDetail>? orderDetails;
  final User? user;
  final Company? company;

  OrderDetailResponse({
    this.id,
    this.note,
    this.totalPrice,
    this.orderStatus,
    this.orderCode,
    this.paymentMethod,
    this.orderDetails,
    this.creationDate,
    this.bookingDate,
    this.user,
    this.company
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) => OrderDetailResponse(
    orderDetails: json["orderDetails"] == null ? [] : List<OrderDetail>.from(json["orderDetails"]!.map((x) => OrderDetail.fromJson(x))),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    company: json["company"] == null ? null : Company.fromJson(json["company"]),
    id: json["id"],
    note: json["note"],
    totalPrice: json["totalPrice"],
    orderStatus: json["orderStatus"],
    paymentMethod: json["paymentMethod"],
    orderCode: json["orderCode"],
    creationDate: json["creationDate"] == null ? null : DateTime.parse(json["creationDate"]),
    bookingDate: json["bookingDate"] == null ? null : DateTime.parse(json["bookingDate"]),
  );

  Map<String, dynamic> toJson() => {
    "orderDetails": orderDetails == null ? [] : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
    "id": id,
    "note": note,
    "totalPrice": totalPrice,
    "orderStatus": orderStatus,
    "orderCode": orderCode,
    "paymentMethod": paymentMethod,
    "creationDate": creationDate?.toIso8601String(),
    "bookingDate": bookingDate?.toIso8601String(),
  };

}

class OrderDetail{
  final String? comboName;
  final int? quantity;
  final double? unitPrice;
  final String? image;
  final String? foods;

  OrderDetail({this.comboName, this.quantity, this.unitPrice, this.image, this.foods});

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    comboName: json["comboName"],
    quantity: json["quantity"],
    unitPrice: json["unitPrice"],
    image: json["image"],
    foods: json["foods"],
  );

  Map<String, dynamic> toJson() => {
    "comboName": comboName,
    "quantity": quantity,
    "unitPrice": unitPrice,
    "image": image,
    "foods": foods,
  };
}

// User
class User {
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final String? code;
  final String? phoneNumber;
  final bool? emailConfirmed;
  final bool? lockoutEnabled;

  User({
    this.id,
    this.name,
    this.email,
    this.image,
    this.code,
    this.phoneNumber,
    this.emailConfirmed,
    this.lockoutEnabled,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      code: json["code"],
      phoneNumber: json["phoneNumber"],
      emailConfirmed: json["emailConfirmed"],
      lockoutEnabled: json["lockoutEnabled"],
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
  };
}

// Company
class Company {
  final String? id;
  final String? address;
  final String? name;
  final TimeOfDay? startWorkHour;

  Company({
    this.id,
    this.name,
    this.address,
    this.startWorkHour
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    startWorkHour: json["startWorkHour"] == null ? null : _parseTime(json["startWorkHour"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "startWorkHour": startWorkHour != null ? "${startWorkHour!.hour.toString().padLeft(2, '0')}:${startWorkHour!.minute.toString().padLeft(2, '0')}" : null,
  };

  // hàm parse từ String sang kiểu TimeOfDay
  static TimeOfDay? _parseTime(String time) {
    final timeParts = time.split(':');
    if (timeParts.length != 3) {
      return null; // Hoặc xử lý lỗi theo yêu cầu của ứng dụng
    }
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) {
      return null; // Hoặc xử lý lỗi
    }
    return TimeOfDay(hour: hour, minute: minute);
  }
}