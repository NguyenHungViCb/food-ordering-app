import 'package:app/models/order/orders.dart';
import 'package:app/models/restaurant.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/home/widget/food_list.dart';
import 'package:app/screens/home/widget/food_list_view.dart';
import 'package:app/screens/home/widget/order/order_processing_card.dart';
import 'package:app/screens/home/widget/slider_List.dart';
import 'package:app/screens/order/order.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selected = 0;
  final pageController = PageController();
  final restaurant = Restaurant.generateRestaurant();
  final controls = [
    {"icon": 'assets/images/account.svg', "text": "Account"},
    {"icon": 'assets/images/shopping-bag.svg', "text": "Orders"},
    {"icon": 'assets/images/location.svg', "text": "Address"}
  ];
  late ResponseOrder order = OrderService().nullSafety;

  @override
  void initState() {
    super.initState();
  }

  getOrder() async {
    var isCheckouted = await GlobalStorage.read(key: "isCheckouted");
    if (isCheckouted == "true" || order.id == '0') {
      var responseOrder = await OrderService().fetchOnGoingOrder();
      await GlobalStorage.delete(key: "isCheckouted");
      setState(() {
        order = responseOrder;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getOrder();
    return Scaffold(
      backgroundColor: kBackground, // background color main
      drawer: ClipRRect(
        child: Drawer(
          child: Column(children: [
            Container(
                padding: const EdgeInsets.fromLTRB(20, 70, 15, 50),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: const Color(0xFF1A1A1A), width: 2),
                            color: Colors.white),
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset('assets/images/avatar.svg',
                            width: 60)),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Nguyễn Hùng Vĩ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("lorem ipsum",
                            style:
                                TextStyle(fontSize: 15, color: Colors.black38))
                      ],
                    )),
                  ],
                )),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.black),
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: Row(children: [
                    SvgPicture.asset(
                      controls[index]['icon']!,
                      width: 30,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      controls[index]['text']!,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ]),
                ),
              ),
            )
          ]),
        ),
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(15.0), bottom: Radius.circular(15.0)),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomAppBar(Icons.menu_sharp, Icons.search_outlined,
            leftCallback: (context) => {Scaffold.of(context).openDrawer()}),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* CustomAppBar(), */
          DestinationCarousel(),
          // RestaurantInfo(),
          FoodList(selected, (int index) {
            setState(() {
              selected = index;
            });
            pageController.jumpToPage(index);
          }, restaurant),
          Expanded(
            child: FoodListView(selected, (int index) {
              setState(() {
                selected = index;
              });
            }, pageController, restaurant),
          ),
          order.id != "0"
              ? GestureDetector(
                  child: OrderProgressCard(
                    order: order,
                    updateOrder: updateOrder,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, OrderScreen.routeName);
                  },
                )
              : const SizedBox.shrink()
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 25),
          //   height: 60,
          //   child: SmoothPageIndicator(
          //       controller: pageController,
          //       count: restaurant.menu.length,
          //   effect: CustomizableEffect(
          //       dotDecoration: DotDecoration(
          //         width: 8,
          //         height: 8,
          //           color:Colors.grey.withOpacity(0.5),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       activeDotDecoration: DotDecoration(
          //         width: 10,
          //         height: 10,
          //         color: kBackground,
          //         borderRadius: BorderRadius.circular(10),
          //         dotBorder: DotBorder(
          //           color: kPrimaryColor,
          //           padding: 2,
          //           width: 2,
          //         )
          //       ),
          //   ),
          //     onDotClicked: (index)=>pageController.jumpToPage(index),
          //   ),
          // )
        ],
      ),
      floatingActionButton: order.id == "0"
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, CartScreen.routeName)
                    .then((value) async {
                  await getOrder();
                });
              },
              backgroundColor: kPrimaryColor,
              elevation: 2,
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
                size: 30,
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  updateOrder(context, _order) {
    setState(() {
      order = _order;
    });
  }
}

//test
class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
