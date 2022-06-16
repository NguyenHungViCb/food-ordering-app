import 'package:app/models/users/auth.dart';
import 'package:app/models/users/users.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/share/text_fields/email.dart';
import 'package:app/share/text_fields/password.dart';
import 'package:app/share/text_fields/text.dart';
import 'package:app/share/text_fields/verify_password.dart';
import 'package:flutter/material.dart';
import 'package:app/share/buttons/primary_button.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Expanded(
          child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                Flexible(
                  child: TextInput(
                      controller: firstNameController,
                      name: "First name",
                      required: true),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: TextInput(
                      controller: lastNameController,
                      name: "Last name",
                      required: true),
                )
              ]),
              const SizedBox(height: 25),
              Email(controller: emailController),
              const SizedBox(height: 25),
              Password(controller: passwordController),
              const SizedBox(height: 25),
              VerifyPassword(
                  controller: confirmPassController,
                  passwordController: passwordController),
              const SizedBox(height: 20),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                const Text(
                  "Fogot password",
                  style: TextStyle(color: Color(0xFFFA5252)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Already have account?",
                      style: TextStyle(color: Color(0xFFADB5BD)),
                    ),
                    Text(
                      " Login Now!",
                      style: TextStyle(color: Color(0xFF4C6EF5)),
                    ),
                  ],
                )
              ]),
              const SizedBox(height: 25),
              PrimaryButton(
                onPressed: signupHandler,
                text: "Sign up",
                loading: true,
              )
            ],
          ),
        ],
      )),
    );
  }

  void signupHandler(context, toggleLoading) async {
    toggleLoading();
    var cartId = await GlobalStorage.read(key: "cart_id");
    var user = await User().localSignup(LocalSignupRequest(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneNumber: emailController.text,
        password: passwordController.text,
        confirmPass: confirmPassController.text,
        cartId: cartId));
    if (user is UserResponse) {
      Navigator.pop(context, user);
    }
    toggleLoading();
  }
}
