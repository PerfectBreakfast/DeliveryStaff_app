import 'dart:convert';

import 'package:flutter/material.dart';

OrderHistoryResponse slotsResponseFromJson(String str) => OrderHistoryResponse.fromJson(json.decode(str));

String slotsResponseToJson(OrderHistoryResponse data) => json.encode(data.toJson());

class OrderHistoryResponse {
  final String id;
  final String? note;
  final double totalPrice;
  final String orderStatus;
  final int orderCode;
  final DateTime creationDate;
  final DateTime deliveryDate;
  final int comboCount;
  final String meal;
  final String companyName;

  OrderHistoryResponse({
      required this.id,
      this.note,
      required this.totalPrice,
      required this.orderStatus,
      required this.orderCode,
      required this.creationDate,
      required this.deliveryDate,
      required this.comboCount,
      required this.meal,
      required this.companyName});


  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) => OrderHistoryResponse(
    id: json["id"],
    note: json["note"],
    totalPrice: json["totalPrice"],
    orderStatus: json["orderStatus"],
    orderCode: json["orderCode"],
    creationDate: DateTime.parse(json["creationDate"]),
    deliveryDate: DateTime.parse(json["deliveryDate"]),
    comboCount: json["comboCount"],
    meal: json["meal"],
    companyName: json["companyName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "note": note,
    "totalPrice": totalPrice,
    "orderStatus": orderStatus,
    "orderCode": orderCode,
    "creationDate": creationDate.toIso8601String(),
    "deliveryDate": deliveryDate.toIso8601String(),
    "comboCount": comboCount,
    "meal": meal,
    "companyName": companyName
  };
}
