import 'package:app/models/cart/getcart/cart.dart';
import 'package:app/models/category.dart';
import 'package:app/models/order/orders.dart';
import 'package:app/models/restaurant.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/home/widget/food_list.dart';
import 'package:app/screens/home/widget/food_list_view.dart';
import 'package:app/screens/home/widget/order/order_processing_card.dart';
import 'package:app/screens/home/widget/slider_List.dart';
import 'package:app/screens/order/order.dart';
import 'package:app/screens/welcome/welcome.dart';
import 'package:app/share/buttons/danger_button.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/cart_service.dart';
import 'package:app/utils/category_service.dart';
import 'package:app/utils/order_service.dart';
import 'package:app/utils/product_service.dart';
import 'package:app/utils/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selected = 0;
  var countCartItems = 0;
  final pageController = PageController();
  Restaurant? restaurant;
  List<Category> categories = [CategoryService().nullSafety];
  bool isLogin = false;
  final controls = [
    {"icon": 'assets/images/account.svg', "text": "Account"},
    {"icon": 'assets/images/shopping-bag.svg', "text": "Orders"},
    {"icon": 'assets/images/location.svg', "text": "Address"}
  ];
  ResponseOrder order = OrderService().nullSafety;

  getOrder() async {
    var isCheckouted = await GlobalStorage.read(key: "isCheckouted");
    print({"isCheckouted": isCheckouted});
    print(order.id);
    if (isCheckouted == "true" || order.id == '0') {
      print("GET ORDER");
      var responseOrder = await OrderService().fetchOnGoingOrder();
      print(responseOrder.id);
      await GlobalStorage.delete(key: "isCheckouted");
      setState(() {
        order = responseOrder;
      });
    }
  }
  updateOrder(context, _order) {
    setState(() {
      order = _order;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getOrder();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final products = await ProductService().loadList();
      setState(() {
        restaurant = Restaurant.generateRestaurant(list: products);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final _categories = await CategoryService().fetchAllCategories();
      setState(() {
        categories = _categories;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserService().isLogin().then((value) => {
            setState(() {
              isLogin = value;
            })
          });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final count = await CartService().countItemInCart();
      setState(() {
        countCartItems = count;
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                    GestureDetector(
                      child: Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLogin == false ? "Anonymous" : "Your name",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          isLogin == false
                              ? const Text("Click to login",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black38))
                              : const SizedBox.shrink()
                        ],
                      )),
                      onTap: () {
                        Navigator.pushNamed(context, WelcomeScreen.routeName);
                      },
                    ),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: DangerousButton(
                  onPressed: (context) async {
                    await GlobalStorage.delete(key: "tokens");
                    await GlobalStorage.delete(key: "cart_id");
                    setState(() {
                      isLogin = false;
                    });
                  },
                  text: "Log out"),
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
          CategoryList(selected, (context, int index) {
            setState(() {
              selected = index;
            });
            pageController.jumpToPage(index);
          }, categories),
          Expanded(
            child: FoodListView(selected, (context, int index) {
              setState(() {
                selected = index;
              });
            }, pageController, categories),
          ),
          GestureDetector(
                  child: OrderProgressCard(
                    order: order,
                    updateOrder: updateOrder,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, OrderScreen.routeName)
                        .then((value) => getOrder());
                  },
                )
        ],
      ),
      floatingActionButton: order.id == "0"
          ? FloatingActionButton(
              onPressed: () async {

                if(countCartItems >0)
                  {
                    Navigator.pushNamed(context, CartScreen.routeName)
                        .then((value) async {
                      await getOrder();
                    });
                  }
                else {
                  FToast().init(context).showToast(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                            color: Color(0xfffa5252),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5))),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/error.svg",
                              width: 18,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Your cart is empty",
                              style: TextStyle(
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      /* backgroundColor: const Color(0xfffa5252), */
                      gravity: ToastGravity.CENTER,
                      toastDuration:
                      const Duration(seconds: 3),
                      positionedToastBuilder:
                          (context, child) {
                        return Positioned(
                            child: child, top: 150, left: 80);
                      });
                }
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
