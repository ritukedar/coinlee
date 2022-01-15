import 'dart:convert';
import 'package:coinlee/constants/appurl.dart';
import 'package:coinlee/helpers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'history_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'referearn.dart';

class IncomeHistoryScreen extends StatefulWidget {
  const IncomeHistoryScreen({Key? key}) : super(key: key);

  static const routename = '/income-history-screen';

  @override
  State<IncomeHistoryScreen> createState() => _IncomeHistoryScreenState();
}

class _IncomeHistoryScreenState extends State<IncomeHistoryScreen> {
  String coinleeUserId = '';
  bool isLoading = true;
  String refCount = '0';
  String token = '';
  String totalcoins = '0';
  String stakeIncome = '0';
  String totalearning = '0';
  String clubIncome = '0';
  String userId = '';
  String usercount = '0';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadRefCount();
  }

  Future loadRefCount() async {
    final userData = Provider.of<AuthProvider>(context);
    http.post(Uri.parse(Appurl.getUserReferalCount), body: {
      'coinlee_user_id': userData.user.userId,
      'token': userData.user.token
    }).then((response) {
      if (json.decode(response.body)['status'] == true) {
        final parsedJson = json.decode(response.body)['result'] as List;
        usercount = parsedJson[0]['user_count'].toString();
        totalcoins = num.parse(parsedJson[0]['total_coin_earn'].toString())
            .toStringAsFixed(4);
        stakeIncome = num.parse(parsedJson[0]['staking_income'].toString())
            .toStringAsFixed(2);
        clubIncome = num.parse(parsedJson[0]['club_income'].toString())
            .toStringAsFixed(2);
        setState(() {
          usercount;
          totalcoins;
          stakeIncome;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
          ),
        ),
        title: const Text('Income History'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(
              child: Text(
              'Fecthing Data...',
              style: TextStyle(fontSize: 15),
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(referearn.routename);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              // side: const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Image.asset(
                                    "assets/images/stack.png",
                                    scale: 3,
                                  ),
                                ),
                                Text(
                                  'Total referrals : $usercount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Referral Amount: $totalcoins',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(History.routename);
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Image.asset(
                                        "assets/images/available.png",
                                        scale: 3,
                                      ),
                                    ),
                                    Text(
                                      'Staking Income : ${stakeIncome} ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Image.asset(
                                      "assets/images/club.png",
                                      scale: 3,
                                    ),
                                  ),
                                  Text(
                                    'Club Income : ${stakeIncome} ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
