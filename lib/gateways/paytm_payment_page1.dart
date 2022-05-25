import 'dart:convert';
import 'dart:io';
import 'package:paytm/paytm.dart';
import 'package:ofledn/provider/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/appbar.dart';
import '../Widgets/success_ticket.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/payment_api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ofledn/common/theme.dart' as T;

class PaytmPaymentPage extends StatefulWidget {
  final int amount;
  PaytmPaymentPage({Key key, this.amount}) : super(key: key);

  @override
  _PaytmPaymentPageState createState() => _PaytmPaymentPageState();
}

class _PaytmPaymentPageState extends State<PaytmPaymentPage> {
  String payment_response = null;

  String website = "DEFAULT";
  bool testing = true;
  bool isBack = true;
  bool isShowing = true;
  var paymentResponse, createdDate, createdTime;
  var currencySymbol;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    currency();
    setState(() {
      isBack = true;
    });
  }

  void currency() {
    // Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: 'en_IN');
    setState(() {
      currencySymbol = format.currencySymbol;
    });
    print("CURRENCY SYMBOL ${format.currencySymbol}"); // ₹
    print("CURRENCY NAME ${format.currencyName}"); // INR
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var payment = Provider.of<PaymentAPIProvider>(context).paymentApi;
    var userDetails = Provider.of<UserProfile>(context).profileInstance;
    return Scaffold(
      appBar: customAppBar(context, "Paytm Payment"),
      backgroundColor: mode.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pay :',
                    style: TextStyle(fontSize: 35.0),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '$currencySymbol',
                    style: TextStyle(fontSize: 35.0),
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    '${widget.amount}',
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                  // Icon(Icons.)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              loading
                  ? Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()),
                    )
                  :
                  // Container(),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            //Firstly Generate CheckSum bcoz Paytm Require this
                            generateTxnToken(0, payment.paytmMerchantId,
                                payment.paytmMerchantKey, userDetails.id);
                          },
                          color: Colors.blue,
                          child: Text(
                            "Pay using Wallet",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            //Firstly Generate CheckSum bcoz Paytm Require this
                            generateTxnToken(1, payment.paytmMerchantId,
                                payment.paytmMerchantKey, userDetails.id);
                          },
                          color: Colors.blue,
                          child: Text(
                            "Pay using Net Banking",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            //Firstly Generate CheckSum bcoz Paytm Require this
                            generateTxnToken(2, payment.paytmMerchantId,
                                payment.paytmMerchantKey, userDetails.id);
                          },
                          color: Colors.blue,
                          child: Text(
                            "Pay using UPI",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            //Firstly Generate CheckSum bcoz Paytm Require this
                            generateTxnToken(3, payment.paytmMerchantId,
                                payment.paytmMerchantKey, userDetails.id);
                          },
                          color: Colors.blue,
                          child: Text(
                            "Pay using Credit Card",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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

  void generateTxnToken(int mode, mid, mKey, uid) async {
    setState(() {
      loading = true;
    });
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl = (testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": mid,
      "key_secret": mKey,
      "website": website,
      "orderId": orderId,
      "amount": widget.amount.toString(),
      "callbackUrl": callBackUrl,
      "custId": "$uid",
      "mode": mode.toString(),
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      String txnToken = response.body;
      if (response.statusCode == 200) {
        setState(() {
          payment_response = txnToken;
        });
      } else if (response.statusCode == 503) {
        showDialogPaytmErrorBox();
      }

      var paytmResponse = Paytm.payWithPaytm(
        mId: mid,
        orderId: orderId,
        txnToken: txnToken,
        callBackUrl: callBackUrl,
        txnAmount: widget.amount.toString(),
        staging: testing,
        appInvokeEnabled: true,
      );

      paytmResponse.then((value) {
        print("Paytm_Value:-> " + "$value");
        setState(() {
          loading = false;
          payment_response = value.toString();
          if ("$value" == '') {
            return;
          } else if (value['errorMessage'] ==
              "App Invoke is not allowed for this merchant") {
            showDialogPaytmErrorBox();
            print("SHOW_YOUR_TOAST_MSG_HERE.");
          } else {
            if (value['response']['STATUS'] == "TXN_SUCCESS") {
              setState(() {
                isShowing = true;
              });
              sendPaymentDetails(value['response']['TXNID'], "Paytm");
            } else if (value['response']['STATUS'] == "TXN_PENDING") {
              sendPaymentDetails(value['response']['TXNID'], "Paytm");
            }
          }
        });
      });

    } catch (e) {
      print(e);
    }
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

  sendPaymentDetails(transactionId, paymentMethod) async {
    try {

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

      if (sendResponse.statusCode == 200) {
        setState(() {
          isShowing = false;
        });

        goToDialog2();
        goToDialog(createdDate, createdTime);
      } else {
        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
  }

  void showDialogPaytmErrorBox() {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Paytm App Error!"),
      content: Text(
          "Please remove Paytm App from your device or choose another payment method."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
