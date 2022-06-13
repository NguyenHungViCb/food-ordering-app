import 'package:app/screens/welcome/welcome.dart';
import 'package:app/share/buttons/danger_button.dart';
import 'package:app/share/constants/colors.dart';
import 'package:app/share/constants/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/users/users.dart';
import '../home.dart';

class CustomDrawer extends StatefulWidget {
  final bool isLogin;
  final Function setIsLogin;
  final int countCartItems;
  final Function setCountCartItems;
  final GetUserInfo? userInfo;

  const CustomDrawer(
      {Key? key,
      required this.isLogin,
      required this.setIsLogin,
      required this.countCartItems,
      required this.setCountCartItems,
      required this.userInfo})
      : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final controls = [
    {
      "icon": 'assets/images/account.svg',
      "text": "Account",
      "routeName": "/account"
    },
    {
      "icon": 'assets/images/shopping-bag.svg',
      "text": "Orders",
      "routeName": "/input route here"
    },
    {
      "icon": 'assets/images/location.svg',
      "text": "Address",
      "routeName": "./address"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                      child: widget.isLogin == true
                          ? Image.network(widget.userInfo?.avatar ?? "",
                              width: 60,
                              errorBuilder: (context, exception, stackTrace) {
                              return Image.asset(
                                "assets/temp/images/defaultAvatar.jpg",
                                width: 60,
                              );
                            })
                          : Image.asset(
                              "assets/temp/images/defaultAvatar.jpg",
                              width: 60,
                            )),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    child: Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isLogin == false
                              ? "Guest"
                              : "${widget.userInfo?.firstName} ${widget.userInfo?.lastName}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        widget.isLogin == false
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
              widget.isLogin ?
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.black),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                  child: GestureDetector(
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
                    onTap: () async {
                      await GlobalStorage.write(
                          key: "previousRoute", value: HomePage.routeName);
                      Navigator.pushNamed(
                          context, controls[index]['routeName']!);
                    },
                  )),
            ),
          ) : const SizedBox.shrink(),
          widget.isLogin
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: DangerousButton(
                      onPressed: (context) async {
                        await GlobalStorage.delete(key: "tokens");
                        await GlobalStorage.delete(key: "cart_id");
                        await GlobalStorage.delete(key: "code");
                        await GlobalStorage.delete(key: "id");
                        await GlobalStorage.delete(key: "discount");
                        widget.setIsLogin(false);
                        widget.setCountCartItems(0);
                      },
                      text: "Log out"),
                )
              : const SizedBox.shrink()
        ]),
      ),
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(15.0), bottom: Radius.circular(15.0)),
    );
  }
}
