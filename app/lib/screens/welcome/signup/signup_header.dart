import 'package:flutter/cupertino.dart';

class SignupHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 8.0, top: 24, left: 16, right: 16),
          child: Column(
            children: const [
              Text(
                "Hello!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Create account to start ordering",
                style: TextStyle(fontSize: 15, color: Color(0xFFADB5BD)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
