import 'package:flutter/cupertino.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 24.0, top: 24, left: 0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
