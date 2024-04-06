import 'package:deliverystaff_app/models/daily_order_detail_response.dart';
import 'package:deliverystaff_app/pages/shippingorder/shipping_order_page.dart';
import 'package:flutter/material.dart';

import '../../common/button/button_widget.dart';
import '../../common/constant.dart';
import '../../common/text/medium.dart';
import '../../common/text/semi_bold.dart';
import '../../common/utils/loading_page.dart';
import '../../network/api.dart';

class ShippingOrderDetailPage extends StatefulWidget {
  final String dailyOrderId;
  const ShippingOrderDetailPage({super.key, required this.dailyOrderId});

  @override
  State<ShippingOrderDetailPage> createState() => _ShippingOrderDetailPageState();
}


class _ShippingOrderDetailPageState extends State<ShippingOrderDetailPage> {

  // refresh Data
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<DailyOrderDetailResponse>(
          future: getDailyOrderDetail(widget.dailyOrderId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            }
            if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: const Center(
                  child: SemiBoldText(
                      text: '[E]Không lấy được thông tin đơn',
                      fontSize: 19,
                      color: AppColor.forText),
                ),
              );
            }
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              DailyOrderDetailResponse dailyOrder = snapshot.data!;
              return Scaffold(
                extendBodyBehindAppBar: true,
                extendBody: true,
                appBar: AppBar(
                  iconTheme: const IconThemeData(
                      color: Colors.white
                  ),
                  automaticallyImplyLeading: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShippingOrderPage()),
                                (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ))
                  ],
                  title: const SemiBoldText(
                      text: 'Chi tiết nhiệm vụ',
                      fontSize: 20,
                      color: Colors.white),
                ),
                  bottomNavigationBar: (dailyOrder.status == 'Waiting' || dailyOrder.status == 'Delivering')
                      ? BottomAppBar(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // chỉ padding ngang
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (dailyOrder.status == 'Waiting') // Nếu đơn hàng đang chờ
                            Expanded(
                              child: MyButton(
                                text: 'Xác nhận lấy đơn',
                                function: () async {
                                  // Hành động khi nút "Xác nhận" được nhấn
                                  bool isSuccess = await confirm(widget.dailyOrderId, context);
                                  if (isSuccess == true) {
                                    setState(() {});
                                  }
                                },
                                textColor: Colors.white,
                                backgroundColor: AppColor.orange,
                              ),
                            ),
                          if (dailyOrder.status == 'Delivering') // Nếu đơn hàng đang được giao
                            Expanded(
                              child: MyButton(
                                text: 'Đóng ca',
                                function: () {
                                  // Hành động khi nút "Đóng ca" được nhấn
                                  // chưa làm api
                                },
                                textColor: Colors.white,
                                backgroundColor: AppColor.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                      : const SizedBox(), // Không hiển thị BottomAppBar cho các trạng thái khác
                body: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 20, bottom: 70),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF4E9C81), // Xanh lá đậm
                      Color(0xFF3D8B70), // Xanh lục đậm
                      Color(0xFF2C7A5F), // Xanh rêu
                      Color(0xFF1B6A4E), // Xanh đậm nhất
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
                              //height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const MediumText(
                                            text: 'Công ty',
                                            fontSize: 14,
                                            color: AppColor.forText),
                                        SemiBoldText(
                                          text: dailyOrder.companyName,
                                          maxLine: 1,
                                          //overflow: TextOverflow.ellipsis, // Thêm để ngăn text tràn
                                          fontSize: 14,
                                          color: AppColor.forText,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Bữa',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: dailyOrder.meal,
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Số điện thoại',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: dailyOrder.phone,
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: AppColor.fadeText,
                                  ),
                                  ...dailyOrder.totalFoodResponses!.map((detail) => Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            detail.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColor.forText, // Đảm bảo bạn đã định nghĩa AppColor trước
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          "${detail.quantity}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColor
                                                .forText, // Đảm bảo bạn đã định nghĩa AppColor trước
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                      .toList(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: const Center(
                child: SemiBoldText(
                    text: '[U]Không lấy được thông tin đơn',
                    fontSize: 19,
                    color: AppColor.forText),
              ),
            );
          }),
    );
  }

}