import 'package:deliverystaff_app/pages/authentication/authentication_page.dart';
import 'package:deliverystaff_app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String?>(
        future: storage.read(key: 'token'),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          // Trong khi chờ đợi, hiển thị CircularProgressIndicator
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Khi có dữ liệu, kiểm tra token và quyết định màn hình nào sẽ hiển thị
          if (snapshot.hasData && snapshot.data != null) {
            // Token tồn tại, chuyển đến HomePage
            return HomePage();
          } else {
            // Không có token, chuyển đến AuthenticationPage
            return AuthenticationPage();
          }
        },
      ),
    );
  }
}