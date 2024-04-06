import 'package:flutter/material.dart';

import '../../../common/constant.dart';
import '../../../common/text/semi_bold.dart';

class PaymentMethod extends StatelessWidget {
  final String paymentMethod;
  const PaymentMethod({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return SemiBoldText(
          fontSize: 14,
          text: paymentMethod == "BANKING" ? 'Ngân hàng'
              : paymentMethod == "MOMO" ? 'Đã hoàn thành'
              : "không xác định",
          color
              : paymentMethod == "BANKING" ? AppColor.forText
              : paymentMethod == "MOMO" ? AppColor.forText
              : AppColor.forText
    );
  }
}