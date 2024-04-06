import 'dart:math';

import 'package:calendar_slider/calendar_slider.dart';
import 'package:deliverystaff_app/models/shipping_order_response.dart';
import 'package:deliverystaff_app/network/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constant.dart';
import '../../common/preference_manager.dart';
import '../../common/text/semi_bold.dart';
import '../orderhistory/component/activity_loading.dart';
import '../orderhistory/component/empty_booking.dart';
import 'component/activity_shipping_order_card.dart';

class ShippingOrderPage extends StatefulWidget {
  const ShippingOrderPage({super.key,});

  @override
  State<ShippingOrderPage> createState() => _ShippingOrderPageState();
}

class _ShippingOrderPageState extends State<ShippingOrderPage> {
  final CalendarSliderController _calendarSliderController = CalendarSliderController();

  late DateTime _selectedDateNotAppBBar = DateTime.now();

  List<ShippingOrderResponse?>? listShippingOrders;

  Random random = Random();

  Future<void> _refreshData() async {
    setState(() {});
  }

  // Common function to get booking data
  Future<List<ShippingOrderResponse?>?> fetchSippingOrders(
      DateTime time) async {
    try {
      return await getShippingOrderList(time);
    } catch (e) {
      // Handle the error if needed
      print('Error fetching OrderHistories: $e');
      return null;
    }
  }

  // Inside your Widget class
  Future<void> _loadData(DateTime time) async {
    //BookingsResponse? bookings = await fetchBookings(searchString: searchString);
    try {
      List<ShippingOrderResponse?>? shippingOrders =
          await getShippingOrderList(time);
      setState(() {
        listShippingOrders = shippingOrders;
      });
    } catch (e) {
      SharedPreferences prefs = await PreferenceManager.getInstance();
      prefs.remove('Name');
      prefs.remove('Email');
      prefs.remove('Roles');
      prefs.remove('Image');
      prefs.remove('CompanyName');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(_selectedDateNotAppBBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.navyPale,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only( right: 5),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: InkWell(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SemiBoldText(text: 'Nhiệm vụ', fontSize: 24, color: AppColor.navyPale),
                        ElevatedButton(
                          onPressed: () {
                            _calendarSliderController.goToDay(DateTime.now());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: SemiBoldText(text: DateFormat('dd/MM/yyyy').format(_selectedDateNotAppBBar),fontSize: 18, color: AppColor.navyPale)  //Text(DateFormat('dd/MM/yyyy').format(_selectedDateNotAppBBar)),
                        ),
                      ],
                    ),
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) =>  const MyBottomBar(selectedInit: 1)),
                    //   );
                    // },
                  ),
                ),
              ),
              backgroundColor: Colors.green,
              pinned: true,
              bottom:  PreferredSize(
                preferredSize: const Size.fromHeight(80), // Chỉnh chiều cao ở đây
                child: Center(
                  child: CalendarSlider(
                          controller: _calendarSliderController,
                          selectedDayPosition: SelectedDayPosition.center,
                          fullCalendarScroll: FullCalendarScroll.horizontal,
                          backgroundColor: Colors.green,
                          fullCalendarWeekDay: WeekDay.long,
                          fullCalendar: false,
                          selectedTileBackgroundColor: Colors.white,
                          monthYearButtonBackgroundColor: Colors.white,
                          monthYearTextColor: Colors.black,
                          tileBackgroundColor: Colors.green,
                          selectedDateColor: Colors.black,
                          dateColor: Colors.white,
                          tileShadow: BoxShadow(
                            color: Colors.black.withOpacity(1),
                          ),
                          locale: 'vi',
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 300)),
                          lastDate: DateTime.now().add(const Duration(days: 5)),
                          onDateSelected: (date) {
                            setState(() {    // nhấn nút thì load lại data
                              _loadData(date);
                              _selectedDateNotAppBBar = date;
                            });
                          },
                        ),
                ),
              ),
            ),
            // Other Sliver Widgets

            FutureBuilder(
                future: fetchSippingOrders(_selectedDateNotAppBBar),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ActivityLoading();
                  }
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (listShippingOrders != null && listShippingOrders!.isNotEmpty) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
                              child: ActivityShippingOrderCard(
                                id: listShippingOrders![index]!.id.toString(),
                                status: listShippingOrders![index]!.status,
                                dailyOrder: listShippingOrders![index]!.dailyOrder,
                              ),
                            );
                          },
                          childCount: listShippingOrders!.length,
                        ),
                      );
                    }
                  }
                  return const SliverToBoxAdapter(child: EmptyBooking());
                }),
          ],
        ),
      ),
    );
  }
}

