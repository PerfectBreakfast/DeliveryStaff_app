import 'dart:convert';
import 'package:deliverystaff_app/models/order_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/preference_manager.dart';
import '../common/utils/ultil_widget.dart';
import 'package:http/http.dart' as http;
import '../models/base_response.dart';
import '../models/daily_order_detail_response.dart';
import '../models/login_Response.dart';
import '../models/order_history_response.dart';
import '../models/profile_response.dart';
import '../models/shipping_order_response.dart';

const String host = 'https://pb-dev-api.azurewebsites.net';

// create storage
const storage = FlutterSecureStorage();

Future<LoginResponse> login(String email, String password, context) async {
  try {
    Utils(context).startLoading();
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'roleId' : "08dc21b9-5b5d-4879-8ceb-3849923e1591"
    };
    debugPrint('---Request login---');
    debugPrint(jsonEncode(requestBody));


    var response = await http.post(
        Uri.parse('$host/api/account/management/login'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'text/plain'
        },
        body: jsonEncode(requestBody)
    );
    //print(response);
    if (response.statusCode >= 200 && response.statusCode <300) {
      final responseJson = jsonDecode(response.body);
      LoginResponse loginResponse =  LoginResponse.fromJson(responseJson);
      if(loginResponse.accessToken != null){
        //write token
        await storage.write(key: 'token', value: loginResponse.accessToken);

        //Parse data
        // String normalizedSource = base64Url.normalize(loginResponse.accessToken!.split(".")[1]);
        // String jsonString= utf8.decode(base64Url.decode(normalizedSource));
        // Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        // int userID = int.parse(jsonMap['_id']);
        //write user id
        await storage.write(key: 'userID', value: loginResponse.userId);

        // updateDeviceToken();

        Utils(context).stopLoading();
        //Utils(context).showSuccessSnackBar('${loginResponse.message}');
        Utils(context).showSuccessSnackBar('login thành công rồi hehe !');
        return loginResponse;
      }else{
        Utils(context).stopLoading();
        Utils(context).showWarningSnackBar('Không tìm thấy token');
        throw Exception('Fail to login: Status code ${response.statusCode} Message ${response.body}');

      }
    } else {
      if(response.statusCode >= 400 && response.statusCode <500){
        final responseJson = jsonDecode(response.body);
        BaseResponse baseResponse =  BaseResponse.fromJson(responseJson);
        Utils(context).stopLoading();
        Utils(context).showWarningSnackBar('${baseResponse.errors}');
        debugPrint(' Status code ${response.statusCode} Thất bại');
        throw Exception('Fail to login: Status code ${response.statusCode} Message ${response.body}');
      }else{
        Utils(context).stopLoading();
        throw Exception('Fail to login: Status code ${response.statusCode} Message ${response.body}');
      }
    }
  }catch (e){
    throw Exception('Fail to login: $e');
  }
}

// Lấy profile / lấy Current USER
Future<ProfileResponse?> getProfile() async {
  try {
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    debugPrint('---Request get profile user : $userID---');
    debugPrint('Token : $token');


    if(userID != null && token != null){
      final response = await http.get(
        Uri.parse('$host/api/account/current-user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300)
      {
        final responseJson = jsonDecode(response.body);
        ProfileResponse profileResponse = ProfileResponse.fromJson(responseJson);
        //await storage.write(key: 'parkingId', value: profileResponse.data!.parkingId.toString());
        return profileResponse;
      }
      else if(response.statusCode == 401)
      {
        SharedPreferences prefs = await PreferenceManager.getInstance();
        prefs.remove('Name');
        prefs.remove('Email');
        prefs.remove('Roles');
        prefs.remove('Image');
        prefs.remove('CompanyName');
        return null;
      }
      else
      {
        throw Exception('Fail to get profile info: Status code ${response.statusCode} Message ${response.body}');
      }
    }
    return null;
  } catch (e) {
    throw Exception('Fail to profile info:: $e');
  }
}

//Get booking list all
Future<List<ShippingOrderResponse?>?> getShippingOrderList(DateTime time) async {
  try {
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    debugPrint('-------- Get booking list ---------');
    debugPrint('User ID : $userID');
    debugPrint('User Token : $token');

    if(userID != null && token != null){
      final response = await http.get(
        Uri.parse('$host/api/v1/shippingorders/delivery-staff?time=$time'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        return List<ShippingOrderResponse>.from(responseJson.map((json) => ShippingOrderResponse.fromJson(json)));
      }
      else
      {
        if(response.statusCode == 404){
          return null;
        }
        throw Exception('Fail to get all booking.: Status code ${response.statusCode} Message ${response.body}');
      }
    }
    return null;
  } catch (e) {
    throw Exception('Fail to get all booking: $e');
  }
}

// Lấy order by Id
Future<OrderDetailResponse> getOrderDetail(id) async {
  try {
    String? token = await storage.read(key: 'token');
    debugPrint('-------- Get Order detail ---------');
    debugPrint('User Token : $token');

    final response = await http.get(
      Uri.parse('$host/api/v1/orders/$id'),
      headers: {
        'accept': 'text/plain',
        'Authorization': 'bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return OrderDetailResponse.fromJson(responseJson);
    } else {
      throw Exception(
          'Failed to fetch parking detail. Status code: ${response.statusCode} Message ${response.body}');
    }
  } catch (e) {
    throw Exception('Fail to get parking detail: $e');
  }
}

// Hoàn thành đơn
Future<bool> completeOrder(String orderId, context) async {
  try {
    String? token = await storage.read(key: 'token');
    debugPrint('-------- Get Order detail ---------');
    final response = await http.patch(
        Uri.parse('$host/api/v1/orders/$orderId/status-complete'),
        headers: {
          'accept': 'text/plain',
          'Content-Type': 'application/json',
          'Authorization': 'bearer $token',
        },
    );
    if (response.statusCode >= 200 && response.statusCode <300) {
      Utils(context).showSuccessSnackBar('Duyệt đơn thành công');
      return true;
    }else {
      if(response.statusCode >= 400 && response.statusCode <500){
        final responseJson = jsonDecode(response.body);
        BaseResponse baseResponse =  BaseResponse.fromJson(responseJson);
        Utils(context).showWarningSnackBar('${baseResponse.errors}');
        debugPrint(' Status code ${response.statusCode} Thất bại');
        return false;
      }else{
        Utils(context).showWarningSnackBar('Duyệt đơn thất bại');
        throw Exception('Fail to Complete Order: Status code ${response.statusCode} Message ${response.body}');
      }
    }
  } catch (e) {
    Utils(context).showWarningSnackBar('Duyệt đơn thất bại');
    throw Exception('Fail to cancel booking: $e');
  }
}

// get list order history of DeliveryStaff
Future<List<OrderHistoryResponse?>?> getOrderHistories(int pageNumber) async{
  try{
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    debugPrint('-------- Get booking list ---------');
    debugPrint('User ID : $userID');
    debugPrint('User Token : $token');

    if(userID != null && token != null){
      final response = await http.get(
        Uri.parse('$host/api/v1/orders/deliverystaff/history?pageNumber=$pageNumber'),
        headers: {
          //'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        return List<OrderHistoryResponse>.from(responseJson.map((json) => OrderHistoryResponse.fromJson(json)));
      }
      else
      {
        if(response.statusCode == 404){
          return null;
        }
        throw Exception('Fail to get all booking.: Status code ${response.statusCode} Message ${response.body}');
      }
    }
    return null;
  } catch(e){
    throw Exception('Fail to cancel booking: $e');
  }
}

// Lấy DailyOrder Detail by DailyOrderId
Future<DailyOrderDetailResponse> getDailyOrderDetail(id) async {
  try {
    String? token = await storage.read(key: 'token');
    debugPrint('-------- Get Order detail ---------');
    debugPrint('User Token : $token');

    final response = await http.get(
      Uri.parse('$host/api/v1/foods/$id/dailyorderid/delivery'),
      headers: {
        'accept': 'text/plain',
        'Authorization': 'bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return DailyOrderDetailResponse.fromJson(responseJson);
    } else {
      throw Exception(
          'Failed to fetch DailyOrder detail. Status code: ${response.statusCode} Message ${response.body}');
    }
  } catch (e) {
    throw Exception('Fail to get dailyOrder detail: $e');
  }
}

// xác nhận lấy đơn
Future<bool> confirm(String id, context) async {
  try {
    String? token = await storage.read(key: 'token');
    debugPrint('-------- Get Order detail ---------');
    debugPrint('User Token : $token');

    final response = await http.put(
      Uri.parse('$host/api/v1/shippingorders/confirmation/$id'),
      headers: {
        'accept': 'text/plain',
        'Authorization': 'bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Utils(context).showSuccessSnackBar('Xác nhận thành công');
      return true;
    } else {
      final responseJson = jsonDecode(response.body);
      BaseResponse baseResponse =  BaseResponse.fromJson(responseJson);
      Utils(context).showWarningSnackBar('${baseResponse.errors}');
      debugPrint(' Status code ${response.statusCode} Thất bại');
      return false;
    }
  } catch (e) {
    throw Exception('Fail to get confirm: $e');
  }
}