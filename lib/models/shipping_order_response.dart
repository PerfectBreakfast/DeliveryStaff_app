import 'dart:convert';

ShippingOrderResponse ShippingOrderResponseFromJson(String str) => ShippingOrderResponse.fromJson(json.decode(str));
String ShippingOrderResponseToJson(ShippingOrderResponse data) => json.encode(data.toJson());

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

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "dailyOrder": dailyOrder.toJson(),
  };
}

class DailyOrder {
  String id;
  double totalPrice;
  int orderQuantity;
  String status;
  DateTime bookingDate;
  Company company;

  DailyOrder({
    required this.id,
    required this.totalPrice,
    required this.orderQuantity,
    required this.status,
    required this.bookingDate,
    required this.company,
  });

  factory DailyOrder.fromJson(Map<String, dynamic> json) => DailyOrder(
    id: json["id"],
    totalPrice: json["totalPrice"].toDouble(),
    orderQuantity: json["orderQuantity"],
    status: json["status"],
    bookingDate: DateTime.parse(json["bookingDate"]),
    company: Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "totalPrice": totalPrice,
    "orderQuantity": orderQuantity,
    "status": status,
    "bookingDate": bookingDate,
    "company": company.toJson(),
  };
}

class Company {
  String id;
  String name;
  String address;
  String startWorkHour;

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.startWorkHour,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    startWorkHour: json["startWorkHour"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "startWorkHour": startWorkHour,
  };
}
