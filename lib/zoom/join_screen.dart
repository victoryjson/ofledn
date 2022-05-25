import 'package:ofledn/Widgets/appbar.dart';
import 'package:ofledn/provider/user_profile.dart';
import 'package:ofledn/zoom/zoom_meeting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class JoinWidget extends StatefulWidget {
  JoinWidget({this.meetingId});
  String meetingId;
  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    meetingIdController.text = widget.meetingId;
    return Scaffold(
      appBar: customAppBar(context, translate("Join_Meeting")),
      backgroundColor: mode.backgroundColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                    readOnly: true,
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: meetingIdController,
                    decoration: InputDecoration(
                      labelText: translate("Meeting_ID"),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                    controller: meetingPasswordController,
                    decoration: InputDecoration(
                      labelText: translate("Meeting_Password"),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return SizedBox(
                      height: 50,
                      width: 200,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          color: mode.easternBlueColor,
                          onPressed: () => joinMeeting(context),
                          child: Text(
                            translate("Join_Meeting"),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          )),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  joinMeeting(BuildContext context) {
    var user = Provider.of<UserProfile>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ZoomMeetingScreen(
              userName:
                  "${user.profileInstance.fname} ${user.profileInstance.lname}",
              meetingId: meetingIdController.text,
              meetingPassword: meetingPasswordController.text);
        },
      ),
    );
  }
}
