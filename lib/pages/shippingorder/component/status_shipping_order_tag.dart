import 'package:flutter/material.dart';

import '../../../common/constant.dart';
import '../../../common/text/medium.dart';

class StatusShippingOrderTag extends StatelessWidget {
  final String status;

  const StatusShippingOrderTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.paleOrange ,
      ),
      child:  MediumText(
          fontSize: 13,
          text: status == "Pending" ? 'Nhiệm vụ của bạn'
              : status == "Confirm" ? "Đang giao"
              : status == "Complete" ? "Hoàn thành"
              : "Hủy đơn",
          color: status == "Pending" ? AppColor.orange
              : status == "Confirm" ? AppColor.navy
              : status == "Complete" ? AppColor.forText
              : Colors.red
      ),
    );
  }
}