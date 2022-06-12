import 'package:app/screens/search/search.dart';
import 'package:app/share/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final IconData leftIcon;
  final IconData? rightIcon;
  final Function? leftCallback;

  const CustomAppBar(this.leftIcon, this.rightIcon, {this.leftCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 25,
        right: 25,
      ),
      decoration: const BoxDecoration(color: kBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: leftCallback != null ? () => leftCallback!(context) : null,
            child: _buildIcon(leftIcon),
          ),
          rightIcon != null
              ? GestureDetector(
                  child: _buildIcon(rightIcon as IconData),
                  onTap: () {
                    Navigator.pushNamed(context, SearchScreen.routeName);
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kBackground,
      ),
      child: Icon(icon),
    );
  }
}
