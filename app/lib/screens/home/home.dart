import 'package:app/models/category.dart';
import 'package:app/models/order/orders.dart';
import 'package:app/models/restaurant.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/home/widget/food_list.dart';
import 'package:app/screens/home/widget/food_list_view.dart';
import 'package:app/screens/home/widget/order/order_processing_card.dart';
import 'package:app/screens/home/widget/slider_List.dart';
import 'package:app/screens/order/order.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/utils/category_service.dart';
import 'package:app/utils/order_service.dart';
import 'package:app/utils/product_service.dart';
import 'package:app/utils/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/screens/home/widget/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/users/users.dart';
import '../../share/constants/storage.dart';
import '../../utils/cart_service.dart';
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
  List<Category> categories = [CategoryService().nullSafety];
  bool isLogin = false;
  ResponseOrder order = OrderService().nullSafety;
  int countCartItems = 0;
  GetUserInfo? userInfo;

  getOrder() async {
    var responseOrder = await OrderService().fetchOnGoingOrder();
    setState(() {
      order = responseOrder;
    });
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
      await getOrder();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      User().getUserInformation().then((value) => {
            setState(() {
              userInfo = value;
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

  checkoutOrder() async {
    var isCheckouted = await GlobalStorage.read(key: "isCheckouted");
    await GlobalStorage.delete(key: "isCheckouted");

    print({isCheckouted: isCheckouted});
    if (isCheckouted == "true") {
      await getOrder();
      await GlobalStorage.delete(key: "isCheckouted");
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkoutOrder();
    return Scaffold(
      backgroundColor: kBackground,
      // background color main
      drawer: CustomDrawer(
        isLogin: isLogin,
        setIsLogin: (value) {
          setState(() {
            isLogin = value;
          });
        },
        countCartItems: countCartItems,
        setCountCartItems: (value) {
          setState(
            () {
              countCartItems = value;
            },
          );
        },
        userInfo: userInfo,
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
            onTap: () async {
              await Navigator.pushNamed(context, OrderScreen.routeName)
                  .then((value) => getOrder());
            },
          )
        ],
      ),
      floatingActionButton: order.id == "0"
          ? FloatingActionButton(
              onPressed: () {
                if (countCartItems > 0) {
                  GlobalStorage.write(
                      key: "previousRoute", value: HomePage.routeName);
                  Navigator.pushNamed(context, CartScreen.routeName)
                      .then((value) async {
                    await getOrder();
                  });
                } else {
                  FToast().init(context).showToast(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                            color: Color(0xfffa5252),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
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
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      /* backgroundColor: const Color(0xfffa5252), */
                      gravity: ToastGravity.CENTER,
                      toastDuration: const Duration(seconds: 3),
                      positionedToastBuilder: (context, child) {
                        return Positioned(child: child, top: 150, left: 80);
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
