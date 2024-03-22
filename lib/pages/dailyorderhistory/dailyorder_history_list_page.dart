import 'package:deliverystaff_app/models/shipping_order_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constant.dart';
import '../../common/preference_manager.dart';
import '../../network/api.dart';
import 'component/activity_card.dart';
import 'component/activity_loading.dart';
import 'component/empty_booking.dart';

class DailyOrderHistoryListPage extends StatefulWidget {
  const DailyOrderHistoryListPage({Key? key}) : super(key: key);

  @override
  State<DailyOrderHistoryListPage> createState() => _DailyOrderHistoryListPageState();
}

class _DailyOrderHistoryListPageState extends State<DailyOrderHistoryListPage> {
  List<ShippingOrderResponse?>? listShippingOrder;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _refreshData() async {
    setState(() {
      _searchController.clear();
      _loadData();
    });
  }

// Common function to get booking data
  Future<List<ShippingOrderResponse?>?> fetchBookings({String? searchString}) async {
    try {
      if (searchString != null) {
        return getShippingOrderList();
      } else {
        return getShippingOrderList();
      }
    } catch (e) {
      // Handle the error if needed
      print('Error fetching bookings: $e');
      return null;
    }
  }


// Inside your Widget class
  Future<void> _loadData({String? searchString}) async {
    //BookingsResponse? bookings = await fetchBookings(searchString: searchString);
    try{
      List<ShippingOrderResponse?>? bookings = await getShippingOrderList();
      setState(() {
        listShippingOrder = bookings;
      });
    }
    catch(e)
    {
      SharedPreferences prefs = await PreferenceManager.getInstance();
      prefs.remove('Name');
      prefs.remove('Email');
      prefs.remove('Roles');
      prefs.remove('Image');
      prefs.remove('CompanyName');
      print('Error fetching bookings: $e');
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              backgroundColor: AppColor.navy,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: const Text('Danh sách đơn'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
              bottom: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColor.navy,
                title: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Center(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (value) {
                        if(value.isNotEmpty){
                          _loadData(searchString: value);
                        }else{
                          _loadData();
                        }
                      },

                      decoration: InputDecoration(
                          hintText: 'Tìm kiếm',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: InkWell( onTap: () {
                            _searchController.clear();
                            _loadData();
                          },child: const Icon(Icons.close_sharp))),
                    ),
                  ),
                ),
              ),
            ),
            // Other Sliver Widgets

            FutureBuilder(
                future: fetchBookings(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const ActivityLoading();
                  }
                  if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                    if(listShippingOrder != null  /*&& ShippingOrder!.data != null*/){
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index)  {
                            return  Padding(
                              padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
                              child: ActivityCard(
                                  bookingId:  listShippingOrder![index]!.id,
                                  dateBook: listShippingOrder![index]!.dailyOrder.bookingDate,
                                  startTime: DateTime.now(),
                                  endTime: DateTime.now(),
                                  licensePlate: listShippingOrder![index]!.dailyOrder.status,
                                  address: listShippingOrder![index]!.dailyOrder.company.address,
                                  parkingName: listShippingOrder![index]!.dailyOrder.company.name,
                                  floorName: listShippingOrder![index]!.dailyOrder.company.name,
                                  slotName: listShippingOrder![index]!.dailyOrder.company.name,
                                  status: listShippingOrder![index]!.status
                              ),
                            );
                          },
                          childCount: listShippingOrder!.length,
                        ),
                      );
                    }
                  }
                  return const SliverToBoxAdapter(child: EmptyBooking());
                }
            ),
          ],
        ),
      ),
    );
  }
}