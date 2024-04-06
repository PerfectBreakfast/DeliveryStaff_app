import 'package:flutter/material.dart';

import '../../../common/constant.dart';
import '../../../common/text/medium.dart';

class StatusOrderDetailTag extends StatelessWidget {
  final String status;
  const StatusOrderDetailTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.navyPale,
      ),
      child:  MediumText(
          fontSize: 13,
          text: status == "Pending" ? 'Chờ thanh toán'
              : status == "Complete" ? 'Đã hoàn thành'
              : status == "Cancel" ? "Đã Hủy"
              : status == 'Paid' ? 'Đã thanh toán'
              : "Hủy đơn",
          color: status == "Pending" ? AppColor.forText
              : status == "Complete" ? AppColor.green
              : status == "Cancel" ? Colors.red
              : status == 'Paid' ? Colors.green
              : Colors.red
      ),
    );
  }
}