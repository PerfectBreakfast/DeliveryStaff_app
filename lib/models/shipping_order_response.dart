import 'dart:convert';

import 'package:flutter/material.dart';


class ShippingOrderResponse {
  String id;
  String status;
  DailyOrder dailyOrder;

  ShippingOrderResponse({
    required this.id,
    required this.status,
    required this.dailyOrder,
  });

  factory ShippingOrderResponse.fromJson(Map<String, dynamic> json) => ShippingOrderResponse(
    id: json["id"],
    status: json["status"],
    dailyOrder: DailyOrder.fromJson(json["dailyOrder"]),
  );
}

class DailyOrder {
  final String id;
  final DateTime bookingDate;
  final String pickupTime;
  final String handoverTime;
  final String status;
  final String meal;
  final Company company;
  final Partner partner;

  DailyOrder({
    required this.id,
    required this.bookingDate,
    required this.pickupTime,
    required this.handoverTime,
    required this.status,
    required this.meal,
    required this.company,
    required this.partner,
  });

  factory DailyOrder.fromJson(Map<String, dynamic> json) => DailyOrder(
    id: json['id'],
    bookingDate: DateTime.parse(json['bookingDate']),
    pickupTime: json['pickupTime'],
    handoverTime: json['handoverTime'],
    status: json['status'],
    meal: json['meal'],
    company: Company.fromJson(json['company']),
    partner: Partner.fromJson(json['partner']),
  );
}

class Company {
  String id;
  String name;
  String address;

  Company({
    required this.id,
    required this.name,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    address: json["address"]
  );
}


class Partner {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final double commissionRate;
  final double longitude;
  final double latitude;

  Partner({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.commissionRate,
    required this.longitude,
    required this.latitude,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      commissionRate: json['commissionRate'].toDouble(),
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
    );
  }
}