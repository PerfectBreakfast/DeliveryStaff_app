import 'package:flutter/material.dart';

import '../../../common/preference_manager.dart';
import '../../../common/text/regular.dart';
import '../../../common/text/semi_bold.dart';
import '../../../models/profile_response.dart';
import '../../../network/api.dart';
import '../../authentication/authentication_page.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  ProfileResponse? userProfile;

  @override
  void initState() {
    super.initState();
    loadProfileInfo();
  }

  Future<void> loadProfileInfo() async {
    String? name = await PreferenceManager.getName();
    List<String>? roles = await PreferenceManager.getRole();
    String? image = await PreferenceManager.getImage();
    String? email = await PreferenceManager.getEmail();

    if (name != null && roles != null && image != null && email != null) {
      setState(() {
        userProfile = ProfileResponse(
          name: name,
          roles: roles,
          image: image,
          email: email,
        );
      });
    } else {
      var profile = await getProfile();
      if (profile != null) {
        // Lưu thông tin vào SharedPreferences
        await PreferenceManager.setName(profile.name!);
        await PreferenceManager.setRole(profile.roles!);
        await PreferenceManager.setImage(profile.image!);
        await PreferenceManager.setEmail(profile.email!); // Bạn cần thêm setEmail trong PreferenceManager

        // Cập nhật UI
        setState(() {
          userProfile = profile;
        });
      } else {
        // Xử lý trường hợp không lấy được thông tin người dùng, ví dụ chuyển đến trang đăng nhập
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthenticationPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu userProfile đã được tải
    if (userProfile != null) {
      var profile = userProfile!;
      String role = profile.roles!.contains('DELIVERY STAFF') ? 'Nhân viên' : 'chưa xác định';
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2.4,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF064789),
            Color(0xFF023B72),
            Color(0xFF022F5B),
            Color(0xFF032445),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profile.image ?? 'https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634_1280.png'), // Cung cấp giá trị mặc định cho ảnh
                ),
              ),
              Column(
                children: [
                  SemiBoldText(text: profile.name ?? 'Tên không rõ', fontSize: 20, color: Colors.white), // Sử dụng giá trị mặc định nếu cần
                  const SizedBox(height: 15),
                  RegularText(text: profile.email ?? 'Email không rõ', fontSize: 12, color: Colors.white), // Sử dụng giá trị mặc định nếu cần
                  const SizedBox(height: 15),
                  RegularText(text: role, fontSize: 12, color: Colors.white)
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // Hiển thị loader hoặc thông báo trong khi chờ dữ liệu
      return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2.4,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF064789),
            Color(0xFF023B72),
            Color(0xFF022F5B),
            Color(0xFF032445),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
  }
}