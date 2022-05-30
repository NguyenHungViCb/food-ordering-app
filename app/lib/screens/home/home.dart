import 'package:app/models/product/product.dart';
import 'package:app/models/restaurant.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/home/widget/food_list.dart';
import 'package:app/screens/home/widget/food_list_view.dart';
import 'package:app/screens/home/widget/slider_List.dart';
import 'package:app/share/constants/colors.dart';
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
  Restaurant? restaurant;
  final controls = [
    {"icon": 'assets/images/account.svg', "text": "Account"},
    {"icon": 'assets/images/shopping-bag.svg', "text": "Orders"},
    {"icon": 'assets/images/location.svg', "text": "Address"}
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final products = await Product().loadList();
      print(products);
      setState(() {
        restaurant = Restaurant.generateRestaurant(list: products);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      // background color main
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
                    Divider(color: Colors.black),
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: Row(children: [
                    SvgPicture.asset(
                      controls[index]['icon']!,
                      width: 30,
                    ),
                    SizedBox(width: 15),
                    Text(
                      controls[index]['text']!,
                      style: TextStyle(fontWeight: FontWeight.w500),
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
          if (restaurant != null)
            FoodList(selected, (int index) {
              setState(() {
                selected = index;
              });
              pageController.jumpToPage(index);
            }, restaurant!),
          if (restaurant != null)
            Expanded(
              child: FoodListView(selected, (int index) {
                setState(() {
                  selected = index;
                });
              }, pageController, restaurant!),
            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CartScreen.routeName);
        },
        backgroundColor: kPrimaryColor,
        elevation: 2,
        child: const Icon(
          Icons.shopping_bag_outlined,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
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
