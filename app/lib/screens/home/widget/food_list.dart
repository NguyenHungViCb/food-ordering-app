import 'package:app/models/category.dart';
import 'package:app/share/constants/colors.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final int selected;
  final Function callback;
  // final Restaurant restaurant;
  final List<Category> categories;

  const CategoryList(this.selected, this.callback, this.categories);

  @override
  Widget build(BuildContext context) {
    // final category = restaurant.menu.keys.toList();
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () => callback(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selected == index ? kPrimaryColor : Colors.white,
                  ),
                  child: Text(
                    categories[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          separatorBuilder: (_, index) => const SizedBox(width: 20),
          itemCount: categories.length),
    );
  }
}
