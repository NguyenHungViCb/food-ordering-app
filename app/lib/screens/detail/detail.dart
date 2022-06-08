import 'package:app/models/cart/addtocart/cart.dart';
import 'package:app/models/cart/getcart/cart.dart';
import 'package:app/models/product/product.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/screens/detail/widget/food_detail.dart';
import 'package:app/screens/detail/widget/food_img.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/cart_service.dart';
import 'package:app/utils/user_service.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Product food;
  const DetailPage(this.food, {Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int counter = -1;
  int inCart = 0;

  void _counter({bool tick = false}) {
    if (counter == -1) {
      setState(() {
        counter = 0;
      });
    }
    setState(() {
      if (tick) {
        counter -= 1;
      } else {
        if (counter < int.parse(widget.food.stock.toString())) {
          counter += 1;
        }
      }
      if (counter < 0) counter = 0;
    });
  }

  void _onTapAddCart() {
    if (widget.food.id != null) {
      if (inCart > counter) {
        // If the quantity in cart is greeter then we removed items
        CartItems()
            .deleteCart(context, widget.food.id!, inCart - counter)
            .then((value) {
          if (value != null) {
            setState(() {
              inCart = value;
            });
          }
        });
      } else {
        // If the quantity in cart is smaller then we added items
        CartItems()
            .addCart(context, widget.food.id!, counter - inCart)
            .then((value) {
          if (value is CartResponse) {
            setState(() {
              inCart = value.succeededInserts[0].quantity;
            });
          }
        });
      }
    }
  }

  Future<void> getQuantityInCart() async {
    var isLogin = await UserService().isLogin();
    if (isLogin == true) {
      var _count = await CartService().count(widget.food.id as String);
      setState(() {
        counter = _count;
        inCart = _count;
      });
    } else {
      var cartId = await GlobalStorage.read(key: "cart_id");
      if (cartId != null) {
        var _count = await CartService().count(widget.food.id!, cartId);
        setState(() {
          counter = _count;
          inCart = _count;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getQuantityInCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(Icons.arrow_back_ios_outlined, Icons.favorite_outline,
                leftCallback: () => Navigator.of(context).pop()),
            FoodImg(widget.food),
            FoodDetail(
              widget.food,
              counter: counter < 0 ? 0 : counter,
              onTapAdd: _counter,
              onTapMinus: () => _counter(tick: true),
              onTapAddCart: _onTapAddCart,
            )
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 56,
        child: RawMaterialButton(
          fillColor: kPrimaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.black,
                size: 30,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  counter < 0 ? "0" : counter.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, CartScreen.routeName)
                .then((value) async => {await getQuantityInCart()});
          },
        ),
      ),
    );
  }
}
