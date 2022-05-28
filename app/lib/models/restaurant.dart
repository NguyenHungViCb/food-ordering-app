import 'package:app/models/food.dart';
import 'package:app/models/product/product.dart';

class Restaurant {
  String name;
  String waitTime;
  String distance;
  String label;
  String logoUrl;
  String desc;
  num score;
  Map<String, List<Product>> menu;

  Restaurant(this.name, this.waitTime, this.distance, this.label, this.logoUrl,
      this.desc, this.score, this.menu);

  static Restaurant generateRestaurant(List<Product> list) {
    return Restaurant(
      'Restaurant',
      '20-30 min',
      '2.4 km',
      'Restaurant',
      'assets/images/res_logo.png',
      'Orange sandwiches is delicious',
      4.7,
      {
        'Recommend': list,
        'Popular': list,
        'Noodles': [],
        'Pizza': [],
      },
    );
  }
}
