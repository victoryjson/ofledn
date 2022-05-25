import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ofledn/Widgets/appbar.dart';
import 'package:ofledn/common/apidata.dart';
import 'package:ofledn/common/global.dart';
import 'package:ofledn/model/content_model.dart';
import 'package:ofledn/provider/content_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/theme.dart' as T;
import 'package:intl/intl.dart';

class GoogleMeetScreen extends StatefulWidget {
  const GoogleMeetScreen({Key key}) : super(key: key);

  @override
  _GoogleMeetScreenState createState() => _GoogleMeetScreenState();
}

class _GoogleMeetScreenState extends State<GoogleMeetScreen> {
  Widget showImage(int index) {
    return googleMeetList[index].image == null
        ? Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            image: DecorationImage(
              image: AssetImage("assets/placeholder/bundle_place_holder.png"),
              fit: BoxFit.cover,
            ),
          ))
        : CachedNetworkImage(
            imageUrl: "${APIData.gMeetImage}${googleMeetList[index].image}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              image: DecorationImage(
                image: AssetImage("assets/placeholder/bundle_place_holder.png"),
                fit: BoxFit.cover,
              ),
            )),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image:
                      AssetImage("assets/placeholder/bundle_place_holder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<GoogleMeet> googleMeetList;

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);

    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    googleMeetList = contentProvider.contentModel.googleMeet;

    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, translate("Google_Meet")),
      backgroundColor: Color(0xFFF1F3F8),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          String dateTime;
          try {
            dateTime =
                "${DateFormat('dd-MM-yyyy | hh:mm aa').format(DateTime.parse("${googleMeetList[index].startTime}"))}";
          } catch (e) {
            dateTime = "${googleMeetList[index].startTime}";
          }
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              padding: EdgeInsets.all(0.0),
              width: MediaQuery.of(context).size.width / 1.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x1c2464).withOpacity(0.30),
                      blurRadius: 16.0,
                      offset: Offset(-13.0, 20.5),
                      spreadRadius: -15.0)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    child: showImage(index),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${googleMeetList[index].meetingTitle}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: mode.txtcolor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        googleMeetList[index].agenda == null
                            ? SizedBox.shrink()
                            : Text(
                                "${googleMeetList[index].agenda}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: mode.txtcolor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            Text(
                              translate("Starts_at"),
                              style: TextStyle(
                                  color: mode.txtcolor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              dateTime,
                              style: TextStyle(
                                  color: mode.easternBlueColor,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                color: mode.easternBlueColor,
                                onPressed: () async {
                                  livoflednAttendance(
                                      meetingType: "2",
                                      meetingId: googleMeetList[index].id);

                                  var _url = googleMeetList[index].meetUrl;
                                  await canLaunch(_url)
                                      ? await launch(_url)
                                      : throw 'Could not launch $_url';
                                },
                                child: Text(
                                  translate("Join_Meeting"),
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: googleMeetList.length,
      ),
    );
  }

  Future<void> livoflednAttendance({String meetingType, int meetingId}) async {
    final res = await post(
        Uri.parse("${APIData.livoflednAttendance}${APIData.secretKey}"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $authToken",
          "Accept": "application/json"
        },
        body: {
          "meeting_type": meetingType,
          "meeting_id": meetingId,
        });

    if (res.statusCode == 200) {
      print("Attendance Done!");
    } else {
      print("Attendance Status :-> ${res.statusCode}");
    }
  }
}
