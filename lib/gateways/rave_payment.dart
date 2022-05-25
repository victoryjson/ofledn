import 'dart:convert';
import 'dart:io';
import 'package:ofledn/provider/payment_api_provider.dart';
import 'package:ofledn/provider/user_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ofledn/common/apidata.dart';
import 'package:ofledn/common/global.dart';
import 'package:ofledn/provider/home_data_provider.dart';
import 'package:ofledn/screens/bottom_navigation_screen.dart';
import 'package:ofledn/widgets/appbar.dart';
import 'package:ofledn/widgets/success_ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave_payment/flutterwave_payment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RavePayment extends StatefulWidget {
  final int amount;

  RavePayment({this.amount});

  @override
  _RavePaymentState createState() => _RavePaymentState();
}

class _RavePaymentState extends State<RavePayment> {
  void loadData() async {
    homeDataProvider = Provider.of<HomeDataProvider>(context, listen: false);
    await Provider.of<UserProfile>(context, listen: false).fetchUserProfile();
    setState(() {
      firstName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .fname;
      lastName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .lname;
      email = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .email;
      phone = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .mobile;
      address = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .address;
      publicKey = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys
          .rAVEPUBLICKEY;
      encryptionKey = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys
          .rAVESECRETKEY;
      currency = "${homeDataProvider.homeModel.currency.currency}";
      amount = widget.amount.toDouble();
      isBack = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  var phone, address;
  var paymentResponse, createdDate, createdTime;
  bool isShowing = true;
  bool isLoading = true;
  bool isBack = false;
  String selectedUrl;
  double progress = 0;
  HomeDataProvider homeDataProvider;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var autoValidate = false;
  bool acceptCardPayment = true;
  bool acceptAccountPayment = true;
  bool acceptMpesaPayment = false;
  bool shouldDisplayFee = true;
  bool acceptAchPayments = false;
  bool acceptGhMMPayments = false;
  bool acceptUgMMPayments = false;
  bool acceptMMFrancophonePayments = false;
  bool live = true;
  bool preAuthCharge = false;
  bool addSubAccounts = false;
  List<SubAccount> subAccounts = [];
  String email;
  double amount;
  String publicKey = "PASTE PUBLIC KEY HERE";
  String encryptionKey = "PASTE ENCRYPTION KEY HERE";
  String txRef = 'TXREF-${DateTime.now().microsecondsSinceEpoch}';
  String orderRef = 'ORDERREF-${DateTime.now().microsecondsSinceEpoch}';
  String narration;
  String currency;
  String country;
  String firstName;
  String lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, "Rave Payment"),
      body: Center(
        child: !isBack
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      startPayment();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.indigo,
                      child: Text(
                        'Pay Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void startPayment() async {
    var initializer = RavePayInitializer(
        redirectUrl: "${APIData.confirmation}",
        amount: amount,
        publicKey: publicKey,
        encryptionKey: encryptionKey,
        subAccounts: subAccounts.isEmpty ? null : null)
      ..country = country != null && country.isNotEmpty ? country : "NG"
      ..currency = currency != null && currency.isNotEmpty ? currency : "NGN"
      ..email = email
      ..fName = firstName
      ..lName = lastName
      ..narration = narration ?? ''
      ..txRef = txRef
      ..orderRef = orderRef
      ..acceptMpesaPayments = acceptMpesaPayment
      ..acceptAccountPayments = acceptAccountPayment
      ..acceptCardPayments = acceptCardPayment
      ..acceptAchPayments = acceptAchPayments
      ..acceptGHMobileMoneyPayments = acceptGhMMPayments
      ..acceptUgMobileMoneyPayments = acceptUgMMPayments
      ..acceptMobileMoneyFrancophoneAfricaPayments = acceptMMFrancophonePayments
      ..displayEmail = false
      ..displayAmount = true
      ..staging = !live
      ..isPreAuth = preAuthCharge
      ..displayFee = shouldDisplayFee;

    RaveResult response = await RavePayManager()
        .prompt(context: context, initializer: initializer);
    if (response.status == RaveStatus.success) {
      sendPaymentDetails(orderRef, "Rave");
    }
    print(response);
    scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(response.message)));
  }

  sendPaymentDetails(transactionId, paymentMethod) async {
    try {
      goToDialog2();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var sendResponse;

      if (!sharedPreferences.containsKey("giftUserId")) {
        sendResponse = await http.post(
          Uri.parse("${APIData.payStore}${APIData.secretKey}"),
          body: {
            "transaction_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "pay_status": "1",
            "sale_id": "null",
          },
          headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"},
        );
      } else {
        int giftUserId = sharedPreferences.getInt("giftUserId");
        int giftCourseId = sharedPreferences.getInt("giftCourseId");

        sendResponse = await http.post(
          Uri.parse("${APIData.giftCheckout}${APIData.secretKey}"),
          body: {
            "gift_user_id": "$giftUserId",
            "course_id": "$giftCourseId",
            "txn_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "pay_status": "1",
          },
        );
        await sharedPreferences.remove("giftUserId");
        await sharedPreferences.remove("giftCourseId");
      }

      paymentResponse = json.decode(sendResponse.body);
      var date = DateTime.now();
      var time = DateTime.now();
      createdDate = DateFormat('d MMM y').format(date);
      createdTime = DateFormat('HH:mm a').format(time);

      if (sendResponse.statusCode == 200 || sendResponse.statusCode == 201) {
        setState(() {
          isShowing = false;
        });

        goToDialog(createdDate, createdTime);
      } else {
        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
  }

  goToDialog(subdate, time) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                      msgResponse: "Your transaction successful",
                      purchaseDate: subdate,
                      time: time,
                      transactionAmount: widget.amount,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBottomNavigationBar(
                                      pageInd: 0,
                                    )));
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                backgroundColor: Colors.white,
                title: Text(
                  "Saving Payment Info",
                  style: TextStyle(color: Color(0xFF3F4654)),
                ),
                content: Container(
                  height: 70.0,
                  width: 150.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    } else {
      Navigator.pop(context);
    }
  }
}
