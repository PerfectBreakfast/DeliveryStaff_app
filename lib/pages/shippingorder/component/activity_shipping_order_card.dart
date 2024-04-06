import 'package:deliverystaff_app/pages/shippingorder/component/status_shipping_order_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../common/constant.dart';
import '../../../common/text/regular.dart';
import '../../../common/text/semi_bold.dart';
import '../../../models/shipping_order_response.dart';
import '../../shippingorderdetail/shipping_order_detail_page.dart';

class ActivityShippingOrderCard extends StatefulWidget {
  String id;
  String status;
  DailyOrder dailyOrder;


  ActivityShippingOrderCard({
    super.key,
    required this.id,
    required this.status,
    required this.dailyOrder
  });

  @override
  State<ActivityShippingOrderCard> createState() => _ActivityShippingOrderCardState();
}

class _ActivityShippingOrderCardState extends State<ActivityShippingOrderCard> {

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  ShippingOrderDetailPage(dailyOrderId: widget.dailyOrder.id,)),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Big Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SemiBoldText(
                              text: widget.dailyOrder.meal,
                              color: AppColor.forText,
                              fontSize: 16,
                            ),
                            SizedBox(
                              height: 27,
                              child: Row(
                                children: [
                                  RegularText(
                                      text: DateFormat('dd/MM/yyyy').format(widget.dailyOrder.bookingDate),
                                      color: AppColor.forText,
                                      fontSize: 15),
                                  const VerticalDivider(
                                      thickness: 1,
                                      color: AppColor.forText,
                                      endIndent: 6,
                                      indent: 6),
                                  RegularText(
                                      text: '${widget.dailyOrder.pickupTime.substring(0,5)} - ${widget.dailyOrder.handoverTime.substring(0,5)}',
                                      color: AppColor.forText,
                                      fontSize: 15),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),
                          ],
                        ),

                      ],
                    ),

                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: AppColor.fadeText,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SemiBoldText(text: widget.dailyOrder.partner.name, fontSize: 15, color: AppColor.forText),
                            const SizedBox(height: 4),
                            RegularText(text: widget.dailyOrder.partner.address, fontSize: 13, color: AppColor.forText),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          color:  AppColor.orange,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SemiBoldText(text: widget.dailyOrder.company.name, fontSize: 15, color: AppColor.forText),
                            const SizedBox(height: 4),
                            RegularText(text: widget.dailyOrder.company.address, fontSize: 13, color: AppColor.forText),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 12,
              right: 12,
              child: StatusShippingOrderTag(status: widget.status,)
          )
        ],
      ),
    );
  }
}