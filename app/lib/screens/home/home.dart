import 'package:app/models/restaurant.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/home/widget/food_list.dart';
import 'package:app/screens/home/widget/food_list_view.dart';
import 'package:app/share/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selected =0;
  final pageController=PageController();
  final restaurant = Restaurant.generateRestaurant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,// background color main
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            Icons.menu_sharp,
            Icons.search_outlined,
            leftCallback: ()=> {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondRoute()),
            )}
          ),
          // RestaurantInfo(),
          FoodList(selected,
              (int index) {
            setState(() {
              selected = index;
            });
            pageController.jumpToPage(index);
              }, restaurant),
          Expanded(
              child: FoodListView(
                selected,
                  (int index){
                  setState(() {
                    selected=index;
                  });
                  },
                  pageController,
                restaurant
              ),
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
        onPressed: (){
          Navigator.pushNamed(context, CartScreen.routeName);
        },
        backgroundColor: kPrimaryColor,
        elevation: 2,
        child: Icon(Icons.shopping_bag_outlined,
        color: Colors.black,
        size: 30,),
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

