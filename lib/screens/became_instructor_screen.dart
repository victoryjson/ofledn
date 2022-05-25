import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;
import 'package:file_picker/file_picker.dart';

class BecomeInstructor extends StatefulWidget {
  @override
  _BecomeInstructorState createState() => _BecomeInstructorState();
}

class _BecomeInstructorState extends State<BecomeInstructor> {
  List<String> genders = ["Select an option", "Male", "Female", "Other"];
  String _gender = "Select an option";
  String _fname = "",
      _lname = "",
      _email = "",
      _phone = "",
      _detail = "",
      _age = "";
  TextStyle _labelStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey[600]);

  TextStyle _mainStyle(txtColor) {
    return TextStyle(color: txtColor, fontSize: 17);
  }

  UnderlineInputBorder enborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr.withOpacity(0.7),
        width: 1.0,
      ),
    );
  }

  File _image;
  final picker = ImagePicker();

  String _dateofbirth = "";
  bool _datesel = false;
  TextEditingController dobCtrl = new TextEditingController();

  File _resume;

  TextEditingController imgCtl = new TextEditingController();
  bool _imgsel = false;

  TextEditingController resumeCtl = new TextEditingController();
  bool _resumeSel = false;

  UnderlineInputBorder foborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 2.0,
      ),
    );
  }

  void _updateDetails(int idx, String value) {
    switch (idx) {
      case 0:
        setState(() {
          _fname = value;
        });
        break;
      case 1:
        setState(() {
          _lname = value;
        });
        break;
      case 2:
        setState(() {
          _email = value;
        });
        break;
      case 3:
        setState(() {
          _phone = value;
        });
        break;
      case 4:
        setState(() {
          _detail = value;
        });
        break;
      case 5:
        setState(() {
          _age = value;
        });
        break;
      default:
    }
  }

  Widget gender(Color borderClr) {
    return Container(
      height: 90,
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == translate("Select_an_option"))
            return translate("Please_select_a_gender");
          else
            return null;
        },
        items: genders.map((String gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender, style: _mainStyle(txtColor)),
          );
        }).toList(),
        onChanged: (newValue) {
          // do other stuff with _category
          setState(() => _gender = newValue);
        },
        value: _gender,
        decoration: InputDecoration(
            labelText: translate("Gender_"),
            focusedBorder: foborder(borderClr),
            enabledBorder: enborder(borderClr),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: _labelStyle),
      ),
    );
  }

  Widget inputField(String label, int idx, Color borderclr) {
    return Container(
      height: idx == 4 ? 150 : 90,
      child: TextFormField(
        validator: (value) {
          if (value == "") {
            return "This field cannot be left empty !";
          }
          return null;
        },
        maxLines: idx == 4 ? 3 : 1,
        onChanged: (value) {
          _updateDetails(idx, value);
        },
        keyboardType: idx == 5 ? TextInputType.number : TextInputType.none,
        cursorColor: Colors.black,
        style: _mainStyle(txtColor),
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: foborder(borderclr),
          enabledBorder: enborder(borderclr),
          labelStyle: _labelStyle,
        ),
      ),
    );
  }

  Widget dateofbirth(Color borderClr) {
    return Container(
      height: 90,
      child: TextFormField(
        controller: dobCtrl,
        validator: (value) {
          if (value == "")
            return translate("Please_choose_a_valid_dob");
          else
            return null;
        },
        readOnly: true,
        style: TextStyle(
            color: txtColor,
            fontSize: 17,
            fontWeight: _datesel ? FontWeight.normal : FontWeight.w600),
        decoration: InputDecoration(
            focusedBorder: foborder(borderClr),
            enabledBorder: enborder(borderClr),
            labelText: translate("Date_of_birth"),
            labelStyle: _labelStyle,
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  DateTime date = DateTime(1900);
                  FocusScope.of(context).requestFocus(new FocusNode());

                  date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  setState(() {
                    _datesel = true;
                    _dateofbirth = date.toIso8601String();
                  });
                  dobCtrl.text = "${date.day}/${date.month}/${date.year}";
                })),
      ),
    );
  }

  String extractName(String path) {
    int i;
    for (i = path.length - 1; i >= 0; i--) {
      if (path[i] == "/") break;
    }
    return path.substring(i + 1);
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imgCtl.text = extractName(_image.path);
        _imgsel = true;
      } else {}
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imgsel = true;
        imgCtl.text = extractName(_image.path);
      } else {}
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(translate("Photo_Library")),
                      onTap: () async {
                        await getImageGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(translate("Camera_")),
                    onTap: () async {
                      await getImageCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget imagepickerfield(Color borderClr) {
    return Container(
      height: 90,
      child: TextFormField(
        controller: imgCtl,
        readOnly: true,
        maxLines: 1,
        validator: (value) {
          if (value.length == 0)
            return translate("Please_upload_your_image_here");
          else
            return null;
        },
        style: TextStyle(
            color: txtColor,
            fontSize: 17,
            fontWeight: _imgsel ? FontWeight.normal : FontWeight.w600),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                  FontAwesomeIcons.upload,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _showPicker(context);
                }),
            focusedBorder: foborder(borderClr),
            enabledBorder: enborder(borderClr),
            labelText: translate("Upload_image"),
            labelStyle: _labelStyle),
      ),
    );
  }

  Future<bool> sendDetailsForInstructor() async {
    String url = APIData.becomeAnInstructor + APIData.secretKey;
    String imageName = _image.path.split('/').last;
    String resumeName = _resume.path.split('/').last;

    var _body = FormData.fromMap({
      "fname": _fname,
      "lname": _lname,
      "age": _age,
      "email": _email,
      "gender": _gender,
      "mobile": _phone,
      "detail": _detail,
      "file": await MultipartFile.fromFile(_image.path, filename: imageName),
      "image": await MultipartFile.fromFile(_resume.path, filename: resumeName)
    });
    Response res;
    try {
      res = await Dio().post(url,
          data: _body,
          options: Options(method: 'POST', headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: "Bearer " + authToken,
            "Accept": "application/json"
          }));
    } catch (e) {}
    if (res.statusCode == 200) {
      return true;
    } else
      return false;
  }

  Widget resumePicker(Color borderClr) {
    return Container(
      height: 90,
      child: TextFormField(
        validator: (value) {
          if (value == "")
            return translate("Please_upload_your_resume_here");
          else
            return null;
        },
        controller: resumeCtl,
        readOnly: true,
        style: TextStyle(
            color: txtColor,
            fontSize: 17,
            fontWeight: _resumeSel ? FontWeight.normal : FontWeight.w600),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                  FontAwesomeIcons.upload,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  FilePickerResult result = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ["pdf", "doc"]);

                  if (result != null) {
                    _resume = File(result.files.single.path);
                    setState(() {
                      _resumeSel = true;
                      resumeCtl.text = extractName(_resume.path);
                    });
                  }
                }),
            focusedBorder: foborder(borderClr),
            enabledBorder: enborder(borderClr),
            labelText: translate("Upload_Resume"),
            labelStyle: _labelStyle),
      ),
    );
  }

  bool submitLoading = false;
  RaisedButton submitButton(Color clr) {
    return RaisedButton(
      color: clr,
      onPressed: () async {
        setState(() {
          submitLoading = true;
        });
        if (_formKey.currentState.validate() == true) {
          bool x = await sendDetailsForInstructor();
          if (x) {
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text(translate("Request_sent"))));
          } else {
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text(translate("Request_sending_failed"))));
          }
        }
        setState(() {
          submitLoading = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(submitLoading ? 5 : 0),
        height: 50,
        width: 120,
        alignment: Alignment.center,
        child: submitLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Center(
                child: Text(
                  translate("Submit_"),
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }

  Widget form(Color borderClr) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: inputField(translate("First_Name"), 0, borderClr)),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                flex: 1,
                child: inputField(translate("Last_Name"), 1, borderClr)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: inputField(translate("Age_"), 5, borderClr),
                )),
            SizedBox(
              width: 10.0,
            ),
            Expanded(flex: 1, child: gender(borderClr)),
          ],
        ),
        inputField(translate("Email_"), 2, borderClr),
        inputField(translate("Contact_No"), 3, borderClr),
        imagepickerfield(borderClr),
        resumePicker(borderClr),
        inputField(translate("Detail_"), 4, borderClr),
        submitButton(Colors.red),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  double fullw, halfw;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color txtColor;

  Widget scaffoldView(mode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
          child: Form(key: _formKey, child: form(mode.notificationIconColor))),
    );
  }

  @override
  Widget build(BuildContext context) {
    fullw = MediaQuery.of(context).size.width - 30;
    halfw = fullw / 2.0;
    T.Theme mode = Provider.of<T.Theme>(context);
    txtColor = mode.txtcolor;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: mode.bgcolor,
      appBar: secondaryAppBar(mode.notificationIconColor, mode.bgcolor, context,
          translate("Become_an_Instructor")),
      body: scaffoldView(mode),
    );
  }
}
