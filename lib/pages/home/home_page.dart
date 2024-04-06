import 'package:deliverystaff_app/pages/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import '../../common/constant.dart';
import '../account/account_profile.dart';
import '../orderhistory/order_history_list_page.dart';
import '../qrpage/qr_page.dart';
import '../shippingorder/shipping_order_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
     const Dashboard(),
     const ShippingOrderPage(),
     const OrderHistoryListPage(),
     const AccountProfile(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Dashboard();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: const Icon(Icons.qr_code_scanner, color: AppColor.navy),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const QRViewExample(),
          ));
        },
      ),


      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Dashboard(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },

                    child: Icon(
                      Icons.dashboard,
                      color: currentTab == 0 ? AppColor.orange : AppColor.navy,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                        const ShippingOrderPage(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Icon(
                      Icons.format_list_bulleted_outlined,
                      color: currentTab == 1 ? AppColor.orange : AppColor.navy,
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                        const OrderHistoryListPage(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Icon(
                      Icons.notifications_active,
                      color: currentTab == 2 ?AppColor.orange : AppColor.navy,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const AccountProfile(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Icon(
                      Icons.settings,
                      color: currentTab == 3 ?AppColor.orange : AppColor.navy,
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}