import 'dart:convert';
import 'dart:io';
import 'package:ofledn/Screens/gift_course_screen.dart';
import 'package:ofledn/model/course_with_progress.dart';
import 'package:ofledn/provider/watchlist_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import '../Screens/no_videos_screen.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../common/theme.dart' as T;
import '../player/clips.dart';
import '../provider/courses_provider.dart';
import '../provider/full_course_detail.dart';
import '../provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ofledn/player/playlist_screen.dart';

// ignore: must_be_immutable
class CourseDetailMenuScreen extends StatefulWidget {
  final FullCourse details;
  final List<String> progress;
  final bool isPurchased;
  final DateTime purchaseDate;
  CourseDetailMenuScreen(
      this.isPurchased, this.details, this.progress, this.purchaseDate);
  @override
  _CourseDetailMenuScreenState createState() => _CourseDetailMenuScreenState();
}

class _CourseDetailMenuScreenState extends State<CourseDetailMenuScreen> {
  bool startFromBeginLoading = false;

  Future<bool> flagInappropriateContent() async {
    String id = widget.details.course.id.toString();
    String message = "Inappropriate Content";
    String url = "${APIData.flagContent}${APIData.secretKey}";

    http.Response res = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": id,
      "detail": message
    });

    print('Flag API Response :- ${res.statusCode}');

    return res.statusCode == 200;
  }

  bool checkDrip({String dripType, String dripDays, String dripDate}) {
    if (dripType == "date") {
      if (dripDate != null)
        return DateTime.parse(dripDate).millisecondsSinceEpoch <=
            DateTime.now().millisecondsSinceEpoch;
      else
        return false;
    } else if (dripType == "days") {
      if (dripDays != null) {
        return widget.purchaseDate
                .add(Duration(days: int.parse(dripDays)))
                .millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch;
      } else
        return false;
    } else if (dripType == null) return true;
  }

  List<Chapter> dripFilteredChapters = [];
  List<Coursofledn> dripFilteredClasses = [];
  void dripFilter() {
    bool isDripEnabled = widget.details.course.dripEnable == "1";
    print("isDripEnabled : $isDripEnabled");

    for (Chapter element in widget.details.course.chapter) {
      if (isDripEnabled) {
        bool isDrip = checkDrip(
            dripType: element.dripType,
            dripDate: element.dripDate,
            dripDays: element.dripDays);
        print("isDrip : $isDrip");
        if (isDrip) {
          dripFilteredChapters.add(element);
          print("Chapter : ${element.chapterName}");
        }
      } else {
        dripFilteredChapters.add(element);
        print("Chapter : ${element.chapterName}");
      }
    }

    for (Coursofledn element in widget.details.course.coursofledn) {
      if (isDripEnabled) {
        bool isDrip = checkDrip(
            dripType: element.dripType,
            dripDate: element.dripDate,
            dripDays: element.dripDays);
        print("isDrip : $isDrip");
        if (isDrip) {
          dripFilteredClasses.add(element);
          print("Class : ${element.title}");
        }
      } else {
        dripFilteredClasses.add(element);
        print("Class : ${element.title}");
      }
    }
  }

  Future<bool> resetProgress() async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";
    http.Response res = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.details.course.id.toString(),
      "checked": "[]"
    });
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getProgress(int id) async {
    String url = "${APIData.courseProgress}${APIData.secretKey}";
    http.Response res = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $authToken",
    }, body: {
      "course_id": id.toString()
    });
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body)["progress"];
      if (body == null) return [];
      Progress pro = Progress.fromJson(body);
      return pro.markChapterId;
    } else {
      return [];
    }
  }

  List<VideoClip> _allClips = [];

  List<VideoClip> getClips(List<Coursofledn> allLessons) {
    List<VideoClip> clips = [];
    allLessons.forEach((element) {
      if (element.type == "video") {
        if (element.url != null) {
          clips.add(VideoClip(
            element.title,
            translate("lecture_"),
            "images/ForBiggerFun.jpg",
            100,
            element.url,
            element.id,
            element.user,
            element.dateTime,
            null,
          ));
        } else {
          if (element.iframeUrl != null) {
            clips.add(VideoClip(
                element.title,
                translate("lecture_"),
                "images/ForBiggerFun.jpg",
                100,
                element.iframeUrl,
                element.id,
                element.user,
                element.dateTime,
                null,
                isIframe: true));
          } else {
            clips.add(VideoClip(
              element.title,
              translate("lecture_"),
              "images/ForBiggerFun.jpg",
              100,
              APIData.videoLink + element.video,
              element.id,
              element.user,
              element.dateTime,
              null,
            ));
          }
        }
      } else if (element.type == "pdf") {
        // Added
        if (element.url != null) {
          clips.add(VideoClip(
            element.title,
            translate("lecture_"),
            "images/ForBiggerFun.jpg",
            100,
            element.url,
            element.id,
            element.user,
            element.dateTime,
            null,
          ));
        } else {
          clips.add(VideoClip(
            element.title,
            translate("lecture_"),
            "images/ForBiggerFun.jpg",
            100,
            APIData.pdfLink + element.pdf,
            element.id,
            element.user,
            element.dateTime,
            null,
          ));
        }
      } else if (element.type == "audio") {
        // Added
        if (element.url != null) {
          clips.add(VideoClip(
            element.title,
            translate("lecture_"),
            "images/ForBiggerFun.jpg",
            100,
            element.url,
            element.id,
            element.user,
            element.dateTime,
            null,
          ));
        } else {
          clips.add(VideoClip(
            element.title,
            translate("lecture_"),
            "images/ForBiggerFun.jpg",
            100,
            '${APIData.domainLink}files/audio/' + element.audio,
            element.id,
            element.user,
            element.dateTime,
            null,
          ));
        }
      }
    });
    return clips;
  }

  List<VideoClip> getLessons(Chapter chap, List<Coursofledn> allLessons) {
    List<Coursofledn> less = [];
    allLessons.forEach((element) {
      if (chap.id.toString() == element.coursechapterId &&
          element.url != null) {
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.video != null) {
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.iframeUrl != null) {
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.pdf != null) {
        // Added
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.audio != null) {
        // Added
        less.add(element);
      }
    });
    if (less.length == 0) return [];
    return getClips(less);
  }

  int findIndToResume(List<Section> sections, List<String> markedSecs) {
    int idx = 0;
    for (int i = 0; i < sections.length; i++) {
      if (markedSecs.contains(sections[i].sectionDetails.id.toString())) {
        idx += sections[i].sectionLessons.length;
      } else {
        break;
      }
    }
    return idx;
  }

  List<Section> generateSections(
      List<Chapter> sections, List<Coursofledn> allLessons) {
    List<Section> sectionList = [];

    sections.forEach((element) {
      List<VideoClip> lessons = getLessons(element, allLessons);
      if (lessons.length > 0) {
        sectionList.add(Section(element, lessons));
        _allClips.addAll(lessons);
      }
    });
    if (sectionList.length == 0) return [];
    return sectionList;
  }

  bool strtBeginLoad = false;

  Widget app(Color txtColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                translate("MENU_"),
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16, color: txtColor),
              )),
          IconButton(
              icon: Icon(
                Icons.clear,
                color: txtColor,
                size: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  Widget menutiles(String title, IconData icon, int idx, Color txtColor) {
    return InkWell(
      onTap: () async {
        if (idx == 0) {
          List<String> marksSecs =
              widget.progress == null ? [] : widget.progress;
          int defaultIdx = findIndToResume(sections, marksSecs);
          defaultIdx = defaultIdx > _allClips.length - 1 ? 0 : defaultIdx;

          print("_allClips != null : ${_allClips != null}");
          print("_allClips.length > 0 : ${_allClips.length > 0}");
          // Resume course or start course
          if (_allClips != null && _allClips.length > 0) {
            bool isWatching =
                Provider.of<WatchlistProvider>(context, listen: false)
                    .isWatching(widget.details.course.id);
            if (!isWatching) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlayListScreen(
                        markedSec: marksSecs,
                        clips: _allClips,
                        sections: sections,
                        defaultIndex: defaultIdx,
                        courseDetails: widget.details,
                      )));
            } else {
              Fluttertoast.showToast(
                  msg: translate("Already_watching_from_another_device"),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmptyVideosPage()));
          }
        } else if (idx == 1) {
          setState(() {
            startFromBeginLoading = true;
          });
          List<String> marksSecs = [];
          setState(() {
            strtBeginLoad = true;
          });
          bool x = await resetProgress();
          setState(() {
            strtBeginLoad = false;
          });

          if (x) courses.setProgress(widget.details.course.id, [], null);
          if (_allClips != null && _allClips.length > 0) {
            bool isWatching =
                Provider.of<WatchlistProvider>(context, listen: false)
                    .isWatching(widget.details.course.id);
            if (!isWatching) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlayListScreen(
                        markedSec: marksSecs,
                        clips: _allClips,
                        sections: sections,
                        defaultIndex: 0,
                        courseDetails: widget.details,
                      )));
            } else {
              Fluttertoast.showToast(
                  msg: translate("Already_watching_from_another_device"),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmptyVideosPage()));
          }
          setState(() {
            startFromBeginLoading = false;
          });
        } else if (idx == 4) {
          bool x = await flagInappropriateContent();
          if (x) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content:
                    Text(translate("Complaint_received_We_will_check_it"))));
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content:
                    Text(translate("Complaint_sending_failed_Retry_later"))));
          }
        } else if (idx == 3) {
          WishListProvider wishListProvider =
              Provider.of<WishListProvider>(context, listen: false);
          if (await wishListProvider.addWishList(widget.details.course.id) ==
              false) {
            await wishListProvider.removeWishList(widget.details.course.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(translate("Course_removed_from_Wish_List")),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(translate("Course_added_to_Wish_List")),
              ),
            );
          }
        } else if (idx == 5) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GiftCourseScreen(
                courseId: widget.details.course.id,
                coursePrice: widget.details.course.discountPrice != null
                    ? (num.parse(
                            widget.details.course.discountPrice.toString()) *
                        selectedCurrencyRate)
                    : (num.parse(widget.details.course.price.toString()) *
                        selectedCurrencyRate),
              ),
            ),
          );
        } else if (idx == 6) {
          await Share.share(
            '${widget.details.course.title} \n${APIData.shareCourse}${widget.details.course.id}/${widget.details.course.title.replaceAll(' ', '-').toLowerCase()}',
            subject: 'Course',
          );
        }
      },
      child: Container(
        height: 50,
        child: Row(children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                icon,
                color: Colors.grey,
              )),
          if (idx == 1)
            Text(
              startFromBeginLoading ? "${translate("Loading_")}" : title,
              style: TextStyle(
                  fontSize: 16, color: txtColor, fontWeight: FontWeight.w600),
            )
          else
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, color: txtColor, fontWeight: FontWeight.w600),
            )
        ]),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String favouriteText;
  CoursesProvider courses;
  List<Section> sections;

  @override
  Widget build(BuildContext context) {
    _allClips.clear();
    courses = Provider.of<CoursesProvider>(context);
    sections = generateSections(dripFilteredChapters, dripFilteredClasses);
    favouriteText = Provider.of<WishListProvider>(context)
            .courseIds
            .contains(widget.details.course.id)
        ? translate("Remove_from_Favourite")
        : translate("Add_to_Favourite");

    bool canUseProgress = widget.progress == null;
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top * 1.3),
        child: Column(
          children: [
            Container(
              height: 80,
              child: Column(
                children: [
                  app(Colors.grey),
                  cusDivider(Colors.grey[300]),
                ],
              ),
            ),
            if (widget.isPurchased)
              menutiles(
                  !canUseProgress
                      ? widget.progress.length > 0
                          ? translate("Resume_")
                          : translate("Start_Course")
                      : translate("Start_Course"),
                  Icons.play_arrow,
                  0,
                  mode.txtcolor),
            if (widget.isPurchased)
              menutiles(translate("Start_From_Beginning"), Icons.replay, 1,
                  mode.txtcolor),
            if (!widget.isPurchased)
              menutiles(favouriteText, Icons.favorite, 3, mode.txtcolor),
            menutiles(translate("Flag_Inappropriate_Content"), Icons.block, 4,
                mode.txtcolor),
            menutiles(translate("Gift_Course"), Icons.card_giftcard_sharp, 5,
                mode.txtcolor),
            menutiles(
                translate("Share Course"), Icons.share_sharp, 6, mode.txtcolor),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dripFilter();
  }
}
