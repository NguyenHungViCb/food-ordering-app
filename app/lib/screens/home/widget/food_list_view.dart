import 'package:app/models/category.dart';
import 'package:app/screens/detail/detail.dart';
import 'package:app/screens/home/widget/food_item.dart';
import 'package:flutter/material.dart';

class FoodListView extends StatelessWidget {
  final int selected;
  final Function callback;
  final PageController pageController;
  // final Restaurant restaurant;
  final List<Category> categories;
  final Function getOrder;

  const FoodListView(this.selected, this.callback, this.pageController,
      this.categories, this.getOrder);

  @override
  Widget build(BuildContext context) {
    // final category = restaurant.menu.keys.toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: PageView(
        controller: pageController,
        onPageChanged: (index) => callback(context, index),
        children: categories
            .map((e) => ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  categories[selected].products[index])))
                          .whenComplete(() => getOrder(context));
                    },
                    child: FoodItem(categories[selected].products[index])),
                separatorBuilder: (_, index) => const SizedBox(height: 15),
                itemCount: categories[selected].products.length))
            .toList(),
      ),
    );
  }
}
