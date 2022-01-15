import 'dart:convert';

import 'package:coinlee/constants/appurl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../helpers/session.dart';
import '../constants/mybutton.dart';

class withdrawl extends StatefulWidget {
  const withdrawl({Key? key}) : super(key: key);

  static const routename = '/withdrawl';

  @override
  _withdrawlState createState() => _withdrawlState();
}

class _withdrawlState extends State<withdrawl> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String availableCoins = '0';
  String coinleeUserId = '';
  String mobile = '';
  String token = '';
  String usdtValue = '0';

  @override
  void dispose() {
    addressController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      getUserId().then((value) => getAvailableCoins());
    });
  }

  Future getUserId() async {
    final userId = await StoreSession.getCoinleeUserId();
    final uMobile = await StoreSession.getUserMobile();
    final ctoken = await StoreSession.getToken();
    setState(() {
      coinleeUserId = userId;
      token = ctoken;
      mobile = uMobile;
    });
  }

  Future getAvailableCoins() async {
    final response = await http.post(Uri.parse(Appurl.getusercoins), body: {
      'coinlee_user_id': coinleeUserId,
      'userMobile': mobile,
      'token': token,
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == true) {
        availableCoins =
            num.parse(json.decode(response.body)['available_coins'])
                .toStringAsFixed(0);
        usdtValue = ((num.parse(availableCoins) * 12) / 80).toString();
      }
      setState(() {
        availableCoins;
        usdtValue;
      });
    }
  }

  Future sendwithdrawlReq() async {
    if (num.parse(amountController.text) >= 5 &&
        addressController.text.length == 34) {
      if (addressController.text[0] == 't' ||
          addressController.text[0] == 'T') {
        final response = await http.post(
            Uri.parse(
                'https://developer.satmatgroup.com/coinlee/appapi/withdrawlRequest'),
            body: {
              'coinlee_user_id': coinleeUserId,
              'withdrawl_address': addressController.text,
              'amount': amountController.text,
              'token': token
            });
        print(response.body);
        if (json.decode(response.body)['status'] == true) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: AlertDialog(
                    title: Text('Withdraw'),
                    content: Text(
                        'Your withdrawl request for ${amountController.text} USDT has been successfully submitted !'),
                    actions: [
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              amountController.text = '';
                              addressController.text = '';
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text('Okay')),
                      )
                    ],
                  ),
                );
              });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter valid USDT TRC20 address'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid amount and TRC20 address'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPaint(
              child: Container(),
              painter: HeaderCurvedContainer(),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 40,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Withdraw Funds',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                //available coins and their USDT value
                "${availableCoins} CNL (${usdtValue} USDT)",
                style: TextStyle(fontSize: 23, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Total Balance",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          onChanged: (val) {
                            if (num.parse(val) > num.parse(usdtValue)) {
                              amountController.text = usdtValue;
                            }
                          },
                          style: const TextStyle(fontSize: 15),
                          controller: amountController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              suffix: TextButton(
                                  onPressed: () {
                                    amountController.text = usdtValue;
                                  },
                                  child: Text('Withdraw All')),
                              prefix: const Text(
                                '\$ ',
                                style: TextStyle(fontSize: 15),
                              ),
                              hintText: 'Enter Amount',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(34)],
                        style: const TextStyle(fontSize: 15),
                        controller: addressController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            label: const Text(
                              ' Withdrawl Address',
                              style: TextStyle(fontSize: 15),
                            ),
                            hintText: 'Withdrawl Address',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Text('Withdrawl fees : 5 USDT', textAlign: TextAlign.left),
                    if (amountController.text.isNotEmpty &&
                        num.parse(amountController.text) > 5)
                      Text(
                          'Withdrawl amount : ${(num.parse(amountController.text) - 5).toStringAsFixed(2)} USDT',
                          textAlign: TextAlign.left),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 100),
                      child: GestureDetector(
                        child: MyButton(text: 'Withdraw'),
                        onTap: sendwithdrawlReq,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff1A22FF);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 210.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
