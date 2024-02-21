import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../common/utils/ultil_widget.dart';
import 'package:http/http.dart' as http;
import '../models/base_response.dart';
import '../models/login_Response.dart';
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
      'password': password
    };
    debugPrint('---Request login---');
    debugPrint(jsonEncode(requestBody));


    var response = await http.post(
        Uri.parse('$host/account/deliverystaff/login'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'text/plain'
        },
        body: jsonEncode(requestBody)
    );
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
        Uri.parse('$host/account/current-user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        ProfileResponse profileResponse = ProfileResponse.fromJson(responseJson);
        //await storage.write(key: 'parkingId', value: profileResponse.data!.parkingId.toString());
        return profileResponse;
      } else {
        throw Exception('Fail to get profile info: Status code ${response.statusCode} Message ${response.body}');
      }
    }
    return null;
  } catch (e) {
    throw Exception('Fail to profile info:: $e');
  }
}

//Get booking list all
Future<List<ShippingOrderResponse?>?> getShippingOrderList() async {
  try {
    String? userID = await storage.read(key: 'userID');
    String? token = await storage.read(key: 'token');
    debugPrint('-------- Get booking list ---------');
    debugPrint('User ID : $userID');
    debugPrint('User Token : $token');

    if(userID != null && token != null){
      final response = await http.get(
        Uri.parse('$host/api/v1/shippingorders/deliverystaff'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <300) {
        final responseJson = jsonDecode(response.body);
        return List<ShippingOrderResponse>.from(responseJson.map((json) => ShippingOrderResponse.fromJson(json)));
      } else {
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