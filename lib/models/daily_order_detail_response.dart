class DailyOrderDetailResponse {
  final String dailyOrderId;
  final String meal;
  final String companyName;
  final String phone;
  final String status;
  final List<FoodResponse> totalFoodResponses;

  DailyOrderDetailResponse({
    required this.dailyOrderId,
    required this.meal,
    required this.companyName,
    required this.phone,
    required this.status,
    required this.totalFoodResponses,
  });

  factory DailyOrderDetailResponse.fromJson(Map<String, dynamic> json) {
    var list = json['totalFoodResponses'] as List;
    List<FoodResponse> foodResponseList = list.map((i) => FoodResponse.fromJson(i)).toList();

    return DailyOrderDetailResponse(
      dailyOrderId: json['dailyOrderId'],
      meal: json['meal'],
      companyName: json['companyName'],
      phone: json['phone'],
      status: json['status'],
      totalFoodResponses: foodResponseList,
    );
  }
}

class FoodResponse {
  final String id;
  final String name;
  final int quantity;
  final String foodName;

  FoodResponse({
    required this.id,
    required this.name,
    required this.quantity,
    this.foodName = '',
  });

  factory FoodResponse.fromJson(Map<String, dynamic> json) {
    return FoodResponse(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      foodName: json['foodName'] ?? '',
    );
  }
}