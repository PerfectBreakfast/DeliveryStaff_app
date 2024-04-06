import 'package:deliverystaff_app/models/order_history_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constant.dart';
import '../../common/preference_manager.dart';
import '../../network/api.dart';
import 'component/activity_card.dart';
import 'component/activity_loading.dart';
import 'component/empty_booking.dart';

class OrderHistoryListPage extends StatefulWidget {
  const OrderHistoryListPage({super.key});

  @override
  State<OrderHistoryListPage> createState() => _OrderHistoryListPageState();
}

class _OrderHistoryListPageState extends State<OrderHistoryListPage> {
  List<OrderHistoryResponse?>? listOrderHistories;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _refreshData() async {
    setState(() {
      _searchController.clear();
      _loadData();
    });
  }

// Common function to get booking data
  Future<List<OrderHistoryResponse?>?> fetchBookings({String? searchString}) async {
    try {
      if (searchString != null) {
        return await getOrderHistories(1);
      } else {
        return await getOrderHistories(1);
      }
    } catch (e) {
      // Handle the error if needed
      print('Error fetching OrderHistories: $e');
      return null;
    }
  }


// Inside your Widget class
  Future<void> _loadData({String? searchString}) async {
    //BookingsResponse? bookings = await fetchBookings(searchString: searchString);
    try{
      List<OrderHistoryResponse?>? orders = await getOrderHistories(1);
      setState(() {
        listOrderHistories = orders;
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
              backgroundColor: AppColor.green,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: const Text('Lịch sử đơn'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
              // bottom: AppBar(
              //   automaticallyImplyLeading: false,
              //   backgroundColor: AppColor.navy,
              //   title: Container(
              //     width: double.infinity,
              //     height: 40,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child:  Center(
              //       child: TextField(
              //         controller: _searchController,
              //         onSubmitted: (value) {
              //           if(value.isNotEmpty){
              //             _loadData(searchString: value);
              //           }else{
              //             _loadData();
              //           }
              //         },
              //
              //         decoration: InputDecoration(
              //             hintText: 'Tìm kiếm',
              //             prefixIcon: const Icon(Icons.search),
              //             suffixIcon: InkWell( onTap: () {
              //               _searchController.clear();
              //               _loadData();
              //             },child: const Icon(Icons.close_sharp))),
              //       ),
              //     ),
              //   ),
              // ),
            ),
            // Other Sliver Widgets

            FutureBuilder(
                future: fetchBookings(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const ActivityLoading();
                  }
                  if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                    if(listOrderHistories != null  /*&& ShippingOrder!.data != null*/){
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index)  {
                            return  Padding(
                              padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
                              child: ActivityCard(
                                  id:  listOrderHistories![index]!.id,
                                  note: listOrderHistories![index]!.note,
                                  totalPrice: listOrderHistories![index]!.totalPrice,
                                  orderStatus: listOrderHistories![index]!.orderStatus,
                                  orderCode: listOrderHistories![index]!.orderCode,
                                  creationDate: listOrderHistories![index]!.creationDate,
                                  deliveryDate: listOrderHistories![index]!.deliveryDate,
                                  comboCount: listOrderHistories![index]!.comboCount,
                                  meal: listOrderHistories![index]!.meal,
                                  companyName: listOrderHistories![index]!.companyName
                              ),
                            );
                          },
                          childCount: listOrderHistories!.length,
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