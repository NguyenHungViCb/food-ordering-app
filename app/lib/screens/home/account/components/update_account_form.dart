import 'package:app/components/default_button.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/users/users.dart';

class AccountDetail extends StatefulWidget {
  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  final addressInput = TextEditingController();
  final emailInput = TextEditingController();
  final avatarInput = TextEditingController();
  final phoneNumberInput = TextEditingController();
  final firstNameInput = TextEditingController();
  final lastNameInput = TextEditingController();
  final birthdayInput = TextEditingController();
  late Future<dynamic> userAddress;

  @override
  void initState() {
    super.initState();
    userAddress = User().getUserInformation();
    getUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: FutureBuilder<dynamic>(
            future: userAddress,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: const Color(0xFF1A1A1A),
                                        width: 2),
                                    color: Colors.white),
                                padding: const EdgeInsets.all(15),
                                child: Image.network(
                                    snapshot.data?.avatar ?? "",
                                    width: 60, errorBuilder:
                                        (context, exception, stackTrace) {
                                  return Image.asset(
                                    "assets/temp/images/defaultAvatar.jpg",
                                    width: 60,
                                  );
                                })),
                            onTap: () {},
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Divider(
                              color: Colors.black, height: 5),
                          const SizedBox(
                            height: 15,
                          ),
                          //Name
                          Row(
                            children: [
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("First Name"),
                                    SizedBox(
                                      child: firstNameTextFormField(),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                    )
                                  ]),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Last Name"),
                                  SizedBox(
                                    child: lastNameTextFormField(),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  )
                                ],
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Email"),
                              emailTextFormField(),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Phone number"),
                              phoneNumberTextFormField(),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Birthday"),
                              birthdayFormField(),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Avatar"),
                              avatarTextFormField(),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: DefaultButton(
                                  text: "Save",
                                  press: () async {
                                    addOrUpdateAccount(
                                        context,
                                        emailInput.text,
                                        firstNameInput.text,
                                        lastNameInput.text,
                                        phoneNumberInput.text,
                                        birthdayInput.text,
                                        avatarInput.text);
                                    Navigator.pushNamed(
                                        context, HomePage.routeName);
                                  })),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return const Text("failed");
              }
            }));
  }

  TextFormField firstNameTextFormField() {
    return TextFormField(
      controller: firstNameInput,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "please input your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField lastNameTextFormField() {
    return TextFormField(
      controller: lastNameInput,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "please input your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField emailTextFormField() {
    return TextFormField(
      controller: emailInput,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "please input your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value != null &&
            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
          return "Email not valid";
        } else if (value == null || value == '') {
          return "Email must not be empty";
        }
        return null;
      },
    );
  }

  TextFormField phoneNumberTextFormField() {
    return TextFormField(
      controller: phoneNumberInput,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "please input your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField birthdayFormField() {
    return TextFormField(
        controller: birthdayInput,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          var selectedDate = DateTime.now();
          final DateTime? selected = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(2025),
          );
          if (selected != null && selected != selectedDate) {
            setState(() {
              birthdayInput.text = DateFormat('MM/dd/yyyy').format(selected);
              //Navigator.pushNamed(context, AccountPage.routeName);
            });
          }
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Please input your birthday",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always));
  }

  TextFormField avatarTextFormField({String? district}) {
    return TextFormField(
        controller: avatarInput,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: district ?? "Please input your avatar",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always));
  }

  String? validateEmail(String value)
  {
    if(value.isEmpty)
    {
      return 'Please enter mail';
    }

    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if(!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }
  void addOrUpdateAccount(context,String email, String firstName, String lastName,
      String phoneNumber, String birthday, String avatar) async {
    try {
      await User().updateAccount(
          context, email, lastName, firstName,birthday, phoneNumber, avatar);
    } catch (e) {
      return null;
    }
  }

  void getUserAddress() async {
    try {
      var userInfo = await User().getUserInformation();
      firstNameInput.text = userInfo.firstName;
      lastNameInput.text = userInfo.lastName;
      emailInput.text = userInfo.email ?? "";
      phoneNumberInput.text = userInfo.phoneNumber ?? "";
      birthdayInput.text = userInfo.birthday == null ? "" : DateFormat('MM/dd/yyyy').format(userInfo.birthday!);
      avatarInput.text = userInfo.avatar;
      addressInput.text = userInfo.address ?? "";
    } catch (e) {
      return null;
    }
  }
}
