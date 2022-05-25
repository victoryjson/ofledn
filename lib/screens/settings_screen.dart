import 'package:ofledn/common/global.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'edit_profile.dart';
import '../model/user_profile_model.dart';
import '../provider/visible_provider.dart';
import '../services/http_services.dart';
import '../provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  //Widget to render one support tile
  Widget supportTile(idx, icons, title, Color txtColor) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 43,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Icon(
          icons,
          size: 15,
          color: Color(0xffb4bac6),
        ),
      ),
      title: Text(
        title,
        maxLines: 2,
        style: TextStyle(
            fontSize: 18.3, fontWeight: FontWeight.w600, color: txtColor),
      ),
      trailing: IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: () {
            if (idx == 0) {
              Navigator.pushNamed(context, "/becameInstructor");
            } else if (idx == 1) {
              Navigator.pushNamed(context, "/aboutUs");
            } else if (idx == 2) {
              Navigator.pushNamed(context, "/contactUs");
            } else if (idx == 3) {
              Navigator.pushNamed(context, "/userFaq");
            } else if (idx == 4) {
              Navigator.pushNamed(context, "/instructorFaq");
            }
          }),
    );
  }

  //Widget to render one personal Info tile
  Widget personalInfoTile(idx, icon, title, subTitle, Color txtColor) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 15,
          color: Color(0xffb4bac6),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.3, fontWeight: FontWeight.w600, color: txtColor),
      ),
      subtitle: Text(
        subTitle == null || subTitle == "null" ? "N/A" : subTitle,
        style: TextStyle(color: txtColor),
      ),
    );
  }

  // Widget to render all personal info tiles
  Widget personalInfoSection(UserProfileModel user, Color txtClr) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1c2464).withOpacity(0.30),
                blurRadius: 25.0,
                offset: Offset(0.0, 20.0),
                spreadRadius: -15.0)
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            personalInfoTile(0, FontAwesomeIcons.user, translate("Name_"),
                user.fname.toString() + " " + user.lname.toString(), txtClr),
            personalInfoTile(1, Icons.mail, translate("Email_"),
                user.email.toString(), txtClr),
            personalInfoTile(3, FontAwesomeIcons.phone,
                translate("Mobile_Number"), user.mobile.toString(), txtClr),
          ],
        ));
  }

  // Widget to render all support tiles
  Widget supportSection(Color txtColor) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1c2464).withOpacity(0.30),
                blurRadius: 25.0,
                offset: Offset(0.0, 20.0),
                spreadRadius: -15.0)
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            supportTile(0, FontAwesomeIcons.questionCircle,
                translate("Become_an_Instructor"), txtColor),
            supportTile(1, FontAwesomeIcons.shieldVirus, translate("About_Us"),
                txtColor),
            supportTile(2, FontAwesomeIcons.facebookMessenger,
                translate("Contact_Us"), txtColor),
            supportTile(
                3, FontAwesomeIcons.handsHelping, translate("FAQ_"), txtColor),
            supportTile(4, FontAwesomeIcons.handsHelping,
                translate("Instructor_FAQ"), txtColor),
          ],
        ));
  }

  // Widget to render all player tiles
  Widget playerSection(Color txtColor) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, 20.0),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 43,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Icon(
                Icons.loop_sharp,
                size: 22,
                color: Color(0xffb4bac6),
              ),
            ),
            title: Text(
              'Video Loop',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18.3, fontWeight: FontWeight.w600, color: txtColor),
            ),
            trailing: Switch(
              onChanged: (newValue) {
                isLoop = newValue;
                setState(() {});
                storage.write(key: 'isLoop', value: '$isLoop');
              },
              value: isLoop,
            ),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 43,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Icon(
                Icons.subtitles,
                size: 22,
                color: Color(0xffb4bac6),
              ),
            ),
            title: Text(
              'Video Subtitle',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18.3, fontWeight: FontWeight.w600, color: txtColor),
            ),
            trailing: Switch(
              onChanged: (newValue) {
                isSubtitle = newValue;
                setState(() {});
                storage.write(key: 'isSubtitle', value: '$isSubtitle');
              },
              value: isSubtitle,
            ),
          ),
        ],
      ),
    );
  }

  //Widget to render heading of sections
  Widget headingOfSection(String txt, Color clr, int type) {
    return Container(
      margin: EdgeInsets.only(bottom: type == 0 ? 12 : 0),
      padding: EdgeInsets.only(left: 22, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt,
            style: TextStyle(
                color: clr, fontSize: 19, fontWeight: FontWeight.w600),
          ),
          if (type == 1)
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: clr,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (contet) => EditProfile()));
                })
        ],
      ),
    );
  }

  bool logoutLoading = false;
  //logout of current session
  Widget logoutSection(Color headingColor) {
    return Container(
      child: FlatButton(
          onPressed: () async {
            setState(() {
              logoutLoading = true;
            });
            bool result = await HttpService().logout();
            setState(() {
              logoutLoading = false;
            });
            if (result) {
              Provider.of<Visible>(context, listen: false).toggleVisible(false);
              Navigator.of(context).pushNamed('/SignIn');
            } else {
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text(translate("Logout_failed"))));
            }
          },
          child: logoutLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(headingColor),
                )
              : Text(
                  translate("LOG_OUT"),
                  style: TextStyle(
                      color: headingColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )),
    );
  }

  //Widget to render a thick line at bottomest of screen
  Widget bottomLine() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 6,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoop = false;
  Future<void> initLoop() async {
    if (await storage.containsKey(key: 'isLoop')) {
      isLoop = await storage.read(key: 'isLoop') == 'true' ? true : false;
      setState(() {});
    }
  }

  bool isSubtitle = false;
  Future<void> initSubtitle() async {
    if (await storage.containsKey(key: 'isSubtitle')) {
      isSubtitle =
          await storage.read(key: 'isSubtitle') == 'true' ? true : false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initLoop();
    initSubtitle();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileModel user = Provider.of<UserProfile>(context).profileInstance;
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: mode.bgcolor,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              headingOfSection(
                  translate("Personal_Information"), mode.headingColor, 1),
              personalInfoSection(user, mode.txtcolor),
              headingOfSection(translate("Support_"), mode.headingColor, 0),
              supportSection(mode.txtcolor),
              headingOfSection(
                  translate("Video Player Setting"), mode.headingColor, 0),
              playerSection(mode.txtcolor),
              logoutSection(mode.headingColor),
              // bottomLine()
            ],
          ),
        ),
      ),
    );
  }
}
