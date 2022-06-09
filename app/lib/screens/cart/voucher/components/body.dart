import 'package:app/models/vouchers/vouchers.dart';
import 'package:app/screens/cart/cart/cart_screen.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/size_config.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({Key? key}) : super(key: key);

  @override
  VoucherPageState createState() => VoucherPageState();
}

class VoucherPageState extends State<VoucherPage> {
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  late Future<List<GetVouchersResponse>?> voucher;

  @override
  void initState() {
    super.initState();
    voucher = VouchersItems().getVouchersForCart(1);
  }

  @override
  Widget build(BuildContext context) {
    const Color secondaryColor = Color(0xFFDC643C);
    const Color primaryColor = Color(0xFFFDBF30);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: FutureBuilder<List<GetVouchersResponse>?>(
        future: voucher,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CouponCard(
                              height: 120,
                              backgroundColor: primaryColor,
                              curveAxis: Axis.vertical,
                              firstChild: Container(
                                decoration: const BoxDecoration(
                                  color: secondaryColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${snapshot.data![index].discount}%",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              'OFF',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                        color: Colors.white, height: 5),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          snapshot.data![index].description,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              secondChild: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Coupon Code',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        InkWell(
                                          child: const Text(
                                            "Apply",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () async {
                                            setState(() async {
                                              addVouchersHandler(context,
                                                  snapshot.data![index].id,
                                                  snapshot.data![index].code,
                                                  snapshot.data![index].discount);
                                              await Navigator.pushNamed(context, CartScreen.routeName);

                                              });
                                          },
                                        )
                                      ],
                                    ),
                                    // const Text(
                                    //   'Coupon Code',
                                    //   textAlign: TextAlign.center,
                                    //   style: TextStyle(
                                    //     fontSize: 11,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.black54,
                                    //   ),
                                    // ),
                                    const SizedBox(height: 4),
                                    Text(
                                      snapshot.data![index].code,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Valid Till'
                                      '- ${DateFormat('MMMM d, y', 'en_US').format(snapshot.data![index].validUntil)}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
          } else if (snapshot.hasError) {
            return const Text('failed');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  void addVouchersHandler(context, id, code, discount) async {
    GlobalStorage.write(key: "voucher_id", value: id);
    GlobalStorage.read(key: "voucher_id").then((value) => print(value));
    GlobalStorage.write(key: "code", value: code);
    GlobalStorage.read(key: "code").then((value) => print("code discount: " + value!));
    GlobalStorage.write(key: "discount", value: discount.toString());
    GlobalStorage.read(key: "discount").then((value) => print("discount percent: " + value!));
  }
}
