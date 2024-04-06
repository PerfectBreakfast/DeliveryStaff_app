import 'package:flutter/material.dart';

import '../../../common/constant.dart';
import '../../../common/text/medium.dart';

class StatusTag extends StatelessWidget {
  final String status;
  const StatusTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: status == "OverTime" ? AppColor.paleOrange : AppColor.navyPale,
      ),
      child:  MediumText(
          fontSize: 13,
          text: status == "Initial" ? 'Chờ xác nhận'
              : status == "Success" ? 'Xe sắp vào'
              : status == "Check_In" ? "Xe sắp ra"
              : status == "Check_Out" ? "Chờ thanh toán"
              : status == "OverTime" ? "Quá giờ"
              : status == "Done" ? "Hoàn thành"
              : status == 'Chờ_lấy_hàng' ? 'chờ lấy hàng'
              : status == 'Paid' ? 'Đã thanh toán'
              : "Hủy đơn",
          color: status == "Initial" ? AppColor.orange
              : status == "Success" ? AppColor.orange
              : status == "Check_In" ? AppColor.forText
              : status == "OverTime" ? AppColor.forText
              : status == "Check_Out" ? AppColor.orange
              : status == "Done" ? Colors.green
              : status == 'Chờ_lấy_hàng' ? Colors.blueAccent
              : status == 'Paid' ? Colors.green
              : Colors.red
      ),
    );
  }
}