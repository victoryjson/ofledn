import 'dart:convert';
import 'package:ofledn/localization/language_screen.dart';
import 'package:ofledn/common/apidata.dart';
import 'package:ofledn/localization/language_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageModel languageModel;
  Future<void> loadData(BuildContext context, {bool loadScreen = true}) async {
    String url = APIData.language + APIData.secretKey;
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      print('Language List Response :-> $data');
      languageModel = LanguageModel.fromJson(await jsonDecode(data));
      // Load Language Code
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      languageCode = sharedPreferences.getString('languageCode');
      languageCode = languageCode == null ? 'en' : languageCode;

      if (loadScreen)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LanguageScreen()));
    } else {
      print('Language Response Code :-> ${response.statusCode}');
    }
  }

  String languageCode;

  Future<void> changeLanguageCode(
      {String language, BuildContext context}) async {
    for (Language _language in languageModel.language) {
      if (_language.name == language) {
        languageCode = _language.local;
        break;
      }
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('languageCode', languageCode);
    await changeLocale(context, languageCode);
    await Fluttertoast.showToast(
        msg: translate("Language_Changed_Successfully"),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    notifyListeners();
  }

  Future<String> translateString({String text, String langCode}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (langCode == null) {
      languageCode = sharedPreferences.getString('languageCode');
      languageCode = languageCode == null ? 'en' : languageCode;
    } else {
      languageCode = langCode;
    }

    String translatedString = '';
    if (sharedPreferences.containsKey('$languageCode-$text') == false) {
      final translator = GoogleTranslator();
      var translation = await translator.translate(text, to: languageCode);
      translatedString = translation.text;
      sharedPreferences.setString('$languageCode-$text', translatedString);
    } else {
      translatedString = sharedPreferences.getString('$languageCode-$text');
    }
    return translatedString;
  }
}
