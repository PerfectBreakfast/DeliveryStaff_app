import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }
 // Name
  static Future<void> setName(String name) async {
    SharedPreferences prefs = await getInstance();
    await prefs.setString('Name', name);
  }

  static Future<String?> getName() async {
    SharedPreferences prefs = await getInstance();
    return prefs.getString('Name');
  }

  // Role
  static Future<void> setRole(List<String> roles) async {
    SharedPreferences prefs = await getInstance();
    await prefs.setStringList('Roles', roles);
  }

  static Future<List<String>?> getRole() async {
    SharedPreferences prefs = await getInstance();
    return prefs.getStringList('Roles');
  }

  // Image
  static Future<void> setImage(String image) async {
    SharedPreferences prefs = await getInstance();
    await prefs.setString('Image', image);
  }

  static Future<String?> getImage() async {
    SharedPreferences prefs = await getInstance();
    return prefs.getString('Image');
  }

  // Company Name
  static Future<void> setCompanyName(String companyName) async {
    SharedPreferences prefs = await getInstance();
    await prefs.setString('CompanyName', companyName);
  }

  static Future<String?> getCompanyName() async {
    SharedPreferences prefs = await getInstance();
    return prefs.getString('CompanyName');
  }

  // Email
  // Company Name
  static Future<void> setEmail(String email) async {
    SharedPreferences prefs = await getInstance();
    await prefs.setString('Email', email);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await getInstance();
    return prefs.getString('Email');
  }

}
