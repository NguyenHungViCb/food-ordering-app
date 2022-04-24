import 'package:flutter/material.dart';

class AuthBottomSheet extends StatelessWidget {
  final Widget child;
  const AuthBottomSheet({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: child,
    );
  }
}
