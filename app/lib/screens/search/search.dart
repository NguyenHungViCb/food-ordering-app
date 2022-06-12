import 'package:app/models/product/product.dart';
import 'package:app/screens/detail/detail.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/utils/search_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;
  List<Product> products = [];

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      var result = await SearchService().search(query);
      setState(() {
        products = result;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 1)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search something",
                  fillColor: kBackground,
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                ),
                onChanged: (query) {
                  _onSearchChanged(query);
                },
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView.separated(
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(products[index])));
                  },
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Row(
                        children: [
                          Image.network(
                            products[index].images![0].src as String,
                            width: 60,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].name as String,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("\$${products[index].price}")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: products.length),
      ),
    );
  }
}
