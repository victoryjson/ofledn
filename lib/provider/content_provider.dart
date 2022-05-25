import 'dart:convert';
import 'package:ofledn/common/apidata.dart';
import 'package:ofledn/model/content_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ContentProvider extends ChangeNotifier {
  ContentModel contentModel;

  Future<ContentModel> getContent(BuildContext context, int id) async {
    String url =
        APIData.courseContent + id.toString() + "?secret=${APIData.secretKey}";
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      contentModel = ContentModel.fromJson(json.decode(res.body));
    } else {
      throw "Can't get content";
    }
    notifyListeners();
    return contentModel;
  }
}
