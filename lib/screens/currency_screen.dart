import 'dart:convert';
import 'package:ofledn/common/apidata.dart';
import 'package:ofledn/common/global.dart';
import 'package:ofledn/provider/home_data_provider.dart';
import 'package:ofledn/screens/bottom_navigation_screen.dart';
import 'package:ofledn/widgets/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key key}) : super(key: key);

  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String dropdownValue = 'USD';
  List<String> currencies = ['USD', 'INR'];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (selectedCurrency != null) dropdownValue = selectedCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Currency'),
      body: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: CircularProgressIndicator(
          color: Colors.red,
        ),
        child: Column(
          children: [
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Currency',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items:
                      currencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                HomeDataProvider homeDataProvider =
                    Provider.of<HomeDataProvider>(context, listen: false);
                String url = APIData.currencyRates + APIData.secretKey;
                http.Response response = await http.post(
                  Uri.parse(url),
                  body: {
                    'currency_from':
                        homeDataProvider.homeModel.currency.currency,
                    'currency_to': dropdownValue,
                  },
                );
                if (response.statusCode == 200) {
                  var body = jsonDecode(response.body);
                  print('Currency Rates API Response :-> $body');
                  selectedCurrency = dropdownValue;
                  selectedCurrencyRate = body['currency'];
                  storage.write(
                      key: 'selectedCurrency', value: selectedCurrency);
                  storage.write(
                      key: 'selectedCurrencyRate',
                      value: selectedCurrencyRate.toString());
                  print('Selected Currency :-> $selectedCurrency');
                  print('Selected Currency Rate :-> $selectedCurrencyRate');
                  await Fluttertoast.showToast(
                      msg: translate("Currency Changed Successfully"),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  print(
                      'Currency Rates API Status Code :-> ${response.statusCode}');
                }
                setState(() {
                  isLoading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyBottomNavigationBar(pageInd: 0),
                  ),
                ).then((value) => setState(() {}));
              },
              child: Text(
                'Apply',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
