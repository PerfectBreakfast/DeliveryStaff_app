import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deliverystaff_app/models/order_detail_response.dart';
import 'package:deliverystaff_app/pages/orderdetail/component/order_info_popup.dart';
import 'package:deliverystaff_app/pages/orderdetail/component/payment_method.dart';
import 'package:deliverystaff_app/pages/shippingorder/shipping_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../common/button/button_widget.dart';
import '../../common/constant.dart';
import '../../common/text/medium.dart';
import '../../common/text/semi_bold.dart';
import '../../common/utils/loading_page.dart';
import '../../common/utils/ultil_widget.dart';
import '../../network/api.dart';
import '../dailyorderhistory/component/status_tag.dart';
import '../home/home_page.dart';
import 'component/status_order_detail_tag.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  // hàm format lại tiền
  String moneyFormat(var number) {
    return NumberFormat.currency(locale: 'vi', symbol: '₫')
        .format(number); // Convert double to string and remove decimal places
  }

  // refresh Data
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<OrderDetailResponse>(
          future: getOrderDetail(widget.orderId),
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
              OrderDetailResponse order = snapshot.data!;
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
                                builder: (context) => const HomePage()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ))
                  ],
                  title: const SemiBoldText(
                      text: 'Chi tiết đơn đặt',
                      fontSize: 20,
                      color: Colors.white),
                ),
                bottomNavigationBar: order.orderStatus == 'Paid' // check xem nếu đơn đã thanh toán mới hiện Button Hoàn thành đơn
                    ? BottomAppBar(
                  color: AppColor.fadeText,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (order.orderStatus == 'Paid')
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0), // chỉ padding ngang
                              child: MyButton(
                                text: 'Xác nhận',
                                function: () async {
                                  if (order.orderStatus == 'Paid') {
                                    bool isSuccess = await completeOrder(widget.orderId, context);
                                    if (isSuccess == true) {
                                      Utils(context).showSuccessSnackBar('Check out thành công');
                                      setState(() {});
                                    }
                                  }
                                },
                                textColor: Colors.white,
                                backgroundColor: AppColor.orange,
                              ),
                            ),
                          ),
                      ],
                    ),
                )
                    : const SizedBox(),
                body: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 20, bottom: 70),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF064789),
                      Color(0xFF023B72),
                      Color(0xFF022F5B),
                      Color(0xFF032445)
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
                                  left: 30, right: 30, top: 20, bottom: 20),
                              //height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  order.id != null
                                      ? Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const MediumText(
                                                    text: 'Tên',
                                                    fontSize: 14,
                                                    color: AppColor.forText),
                                                SemiBoldText(
                                                    text: order.user!.name!,
                                                    fontSize: 14,
                                                    color: AppColor.forText)
                                              ],
                                            ),
                                            SizedBox(
                                              height: order.totalPrice != null
                                                  ? 5
                                                  : 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const MediumText(
                                                    text: 'Số điện thoại',
                                                    fontSize: 14,
                                                    color: AppColor.forText),
                                                SemiBoldText(
                                                    text: order
                                                        .user!.phoneNumber!,
                                                    fontSize: 14,
                                                    color: AppColor.forText)
                                              ],
                                            ),
                                            SizedBox(
                                              height: order.totalPrice != null
                                                  ? 5
                                                  : 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const MediumText(
                                                    text: 'Email',
                                                    fontSize: 14,
                                                    color: AppColor.forText),
                                                SemiBoldText(
                                                    text: order.user!.email!,
                                                    fontSize: 14,
                                                    color: AppColor.forText)
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SemiBoldText(
                                          text: 'Khách vãng lai',
                                          fontSize: 20,
                                          color: AppColor.navy),

                                  // order.note != null
                                  //     ? Column(
                                  //   children: [
                                  //     // const Divider(
                                  //     //   thickness: 1,
                                  //     //   color: AppColor.fadeText,
                                  //     // ),
                                  //     Row(
                                  //       mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         const MediumText(
                                  //             text: 'Số người đặt hộ',
                                  //             fontSize: 14,
                                  //             color: AppColor.forText),
                                  //         SemiBoldText(
                                  //             text: order.user!.phoneNumber!,
                                  //             fontSize: 14,
                                  //             color: AppColor.forText)
                                  //       ],
                                  //     ),
                                  //     const SizedBox(
                                  //       height: 8,
                                  //     ),
                                  //     Row(
                                  //       mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         const MediumText(
                                  //             text: 'Tên người đặt hộ',
                                  //             fontSize: 14,
                                  //             color: AppColor.forText),
                                  //         SemiBoldText(
                                  //             text: order.user!.name!,
                                  //             fontSize: 14,
                                  //             color: AppColor.forText)
                                  //       ],
                                  //     ),
                                  //   ],
                                  // )
                                  //     : const SizedBox.shrink(),
                                  //
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     const MediumText(
                                  //         text: 'Biển số xe',
                                  //         fontSize: 14,
                                  //         color: AppColor.forText),
                                  //     SemiBoldText(
                                  //         text: order.orderDetails![0].comboName!,
                                  //         fontSize: 14,
                                  //         color: AppColor.forText)
                                  //   ],
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     const MediumText(
                                  //         text: 'Hãng xe',
                                  //         fontSize: 14,
                                  //         color: AppColor.forText),
                                  //     SemiBoldText(
                                  //         text: order.orderDetails![0].comboName!,
                                  //         fontSize: 14,
                                  //         color: AppColor.forText)
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20, bottom: 20),
                              //height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Địa chỉ'),
                                            content: Text(order.company!.name!),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Đóng'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const MediumText(
                                            text: 'Địa chỉ',
                                            fontSize: 14,
                                            color: AppColor.forText),
                                        Expanded( // Sử dụng Expanded thay vì Flexible để chiếm dụng mọi không gian còn lại
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 60.0),
                                            child: Row(
                                              children: [
                                                Expanded( // Bọc text trong Expanded để nó chiếm dụng mọi không gian còn lại trừ icon
                                                  child: SemiBoldText(
                                                    text: order.company!.name!,
                                                    maxLine: 1,
                                                    //overflow: TextOverflow.ellipsis, // Thêm để ngăn text tràn
                                                    fontSize: 14,
                                                    color: AppColor.forText,
                                                  ),
                                                ),
                                                const SizedBox(width: 5), // Khoảng cách giữa text và icon
                                                const Icon(
                                                  Icons.remove_red_eye_rounded,
                                                  color: AppColor.orange,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Ngày đặt',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: DateFormat('dd/MM/yyyy')
                                              .format(order.creationDate!),
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Ngày giao',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: order.bookingDate == null
                                              ? '-----'
                                              : DateFormat('dd/MM/yyyy')
                                                  .format(order.bookingDate!),
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Giờ giao',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      Builder( // Sử dụng Builder để có BuildContext
                                        builder: (context) {
                                          // Kiểm tra xem startWorkHour có phải là null không
                                          final startWorkHour = order.company?.startWorkHour;
                                          // Nếu không null, định dạng và hiển thị, ngược lại hiển thị một giá trị mặc định hoặc thông báo
                                          final timeString = startWorkHour != null ? startWorkHour.format(context) : 'Không xác định';
                                          return SemiBoldText(text: timeString, fontSize: 14, color: AppColor.forText);
                                        },
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: AppColor.fadeText,
                                  ),
                                  ...order.orderDetails!
                                      .map((detail) => Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    detail.foods!,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppColor
                                                          .forText, // Đảm bảo bạn đã định nghĩa AppColor trước
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  "${detail.quantity} x ${moneyFormat(detail.unitPrice)}",
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
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20, bottom: 20),
                              height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const MediumText(
                                          text: 'Trạng thái',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      StatusOrderDetailTag(
                                        status: order.orderStatus!,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Mã đơn',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      Row(
                                        children: [
                                          SemiBoldText(
                                              text:
                                                  '#${order.orderCode!.toString()}',
                                              fontSize: 14,
                                              color: AppColor.forText),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: order.orderStatus!));
                                            },
                                            child: const Icon(
                                                Icons.content_copy,
                                                color: AppColor.orange,
                                                size: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Phương thức',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      PaymentMethod(paymentMethod: order.paymentMethod!)  // gọi class đổi tên phương thức Tiếng Anh sang tiếng Việt
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Tổng cộng',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: moneyFormat(order.totalPrice!),
                                          fontSize: 25,
                                          color: AppColor.forText)
                                    ],
                                  ),
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
