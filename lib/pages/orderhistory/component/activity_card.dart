import 'package:deliverystaff_app/pages/orderhistory/component/status_order_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../common/constant.dart';
import '../../../common/text/regular.dart';
import '../../../common/text/semi_bold.dart';
import '../../orderdetail/order_detail_page.dart';

class ActivityCard extends StatefulWidget {
  final String id;
  final String? note;
  final double totalPrice;
  final String orderStatus;
  final int orderCode;
  final DateTime creationDate;
  final DateTime deliveryDate;
  final int comboCount;
  final String meal;
  final String companyName;

  const ActivityCard({super.key,
    required this.id,
    required this.note,
    required this.totalPrice,
    required this.orderStatus,
    required this.orderCode,
    required this.creationDate,
    required this.deliveryDate,
    required this.comboCount,
    required this.meal,
    required this.companyName});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  OrderDetailPage(orderId: widget.id,)),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SvgPicture.asset('assets/icon/car.svg',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Đã giao thành công',
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(widget.deliveryDate)} • ${widget.comboCount} món',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}