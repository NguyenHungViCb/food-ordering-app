import 'package:app/models/api/base_response.dart';
import 'package:app/screens/order_management/order_cart.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/utils/api_service.dart';
import 'package:app/utils/user_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OrderManagement extends StatefulWidget {
  static const routeName = "/order_management";
  const OrderManagement({Key? key}) : super(key: key);

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  static const _pageSize = 15;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _pageFetch(pageKey);
    });
  }

  _pageFetch(int pageKey) async {
    try {
      final userInfo = await UserService().getUserInfo();
      final response = await ApiService().get(
          "/api/orders/all?user_id=${userInfo['id']}&limit=${_pageSize.toString()}&page=${pageKey.toString()}");
      final result = responseFromJson(response.body).data['rows'];
      final isLastPage = result.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(result);
      } else {
        final int nextPageKey = pageKey + result.length as int;
        _pagingController.appendPage(result, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.black),
          ),
          foregroundColor: Colors.black,
          backgroundColor: kPrimaryColor,
        ),
        backgroundColor: kBackground,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.only(top: 20, left: 10, bottom: 5),
              child: Text("Previous orders")),
          Expanded(
            child: PagedListView.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) =>
                      OrderCard(order: item)),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          )
        ]));
  }
}
