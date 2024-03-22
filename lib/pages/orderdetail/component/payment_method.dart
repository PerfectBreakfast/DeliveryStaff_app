import 'package:flutter/material.dart';

import '../../../common/constant.dart';
import '../../../common/text/semi_bold.dart';

class PaymentMethod extends StatelessWidget {
  final String paymentMethod;
  const PaymentMethod({Key? key, required this.paymentMethod}) : super(key: key);

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