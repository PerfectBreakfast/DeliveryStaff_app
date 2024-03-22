import 'package:deliverystaff_app/pages/authentication/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/constant.dart';
import '../../common/preference_manager.dart';
import '../../common/text/medium.dart';
import '../../common/text/regular.dart';
import '../../common/text/semi_bold.dart';
import '../../common/utils/ultil_widget.dart';
import '../../network/api.dart';
import 'component/linechart.dart';

class ShippingOrderPage extends StatefulWidget{
  const ShippingOrderPage({Key? key}) : super(key: key);

  @override
  State<ShippingOrderPage> createState() => _ShippingOrderPageState();
}

class _ShippingOrderPageState extends State<ShippingOrderPage> {

  String? name;
  List<String?>? roles;
  String? image;
  String? companyName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserInfo();
    });
  }

  void loadUserInfo() async {
    final _name = await PreferenceManager.getName();
    final _roles = await PreferenceManager.getRole();
    final _image = await PreferenceManager.getImage();
    final _companyName = await PreferenceManager.getCompanyName();

    if (_name != null && _roles != null && _image != null && _companyName != null) {
      setState(() {
        name = _name;
        roles = _roles;
        image = _image;
        companyName = _companyName;
      });
    } else {
      final profile = await getProfile();
      if (profile != null) {
        // Cập nhật SharedPreferences
        await PreferenceManager.setName(profile.name!);
        await PreferenceManager.setRole(profile.roles!);
        await PreferenceManager.setImage(profile.image!);
        await PreferenceManager.setCompanyName(profile.companyName!);

        // Cập nhật UI
        setState(() {
          name = profile.name;
          roles = profile.roles;
          image = profile.image;
          companyName = profile.companyName;
        });
      }
      else
      {
        // Chuyển hướng người dùng sang AuthenticationPage nếu profile == null
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthenticationPage()));
        Utils(context).showWarningSnackBar('Time Out');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegularText(
                          text: '${roles?.contains('DELIVERY STAFF') ?? false ? 'Nhân viên' : 'chưa xác định'} - ${companyName ?? 'Tên công ty không rõ'}',
                          fontSize: 15,
                          color: AppColor.forText,
                        ),
                        SemiBoldText(text: name ?? 'Đang tải...', fontSize: 25, color: Colors.black),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(image ?? 'https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634_1280.png'),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32,),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.navy,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child:  Center(
                                  child: SvgPicture.asset('assets/icon/timer.svg'),
                                ),
                              ),
                              const SemiBoldText(text: '50', fontSize: 40, color: Colors.white),
                              const SemiBoldText(text: 'Đơn hôm nay', fontSize: 14, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Flexible(
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.forText,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child:  Center(
                                  child: SvgPicture.asset('assets/icon/schedule.svg'),
                                ),
                              ),
                              const SemiBoldText(text: '220', fontSize: 40, color: Colors.white),
                              const SemiBoldText(text: 'Tổng số đơn', fontSize: 14, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32,),
                const SemiBoldText(text: 'Tổng doanh thu ', fontSize: 20, color: AppColor.forText),
                const SizedBox(height: 16,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColor.navyPale,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 325,
                  child:  Column(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 26.0, right: 16),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  VerticalDivider(width: 18, color: AppColor.orange, thickness: 3 , endIndent: 7),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MediumText(text: 'Tổng tiền', fontSize: 12, color: AppColor.forText),
                                      SemiBoldText(text: '8 750 000 đ', fontSize: 20, color: AppColor.forText)
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(onPressed: () {

                              }, icon: const Icon(Icons.calendar_month))


                            ],
                          ),
                        ),
                      ),
                      const LineChartSample2(),
                    ],
                  ),
                  // Other container properties or child widgets can be added here
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}