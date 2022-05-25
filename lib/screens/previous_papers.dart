import 'package:ofledn/Screens/previous_papers_loading_screen.dart';
import 'package:ofledn/Widgets/appbar.dart';
import 'package:ofledn/provider/content_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class PreviousPapers extends StatefulWidget {
  const PreviousPapers({Key key}) : super(key: key);

  @override
  _PreviousPapersState createState() => _PreviousPapersState();
}

class _PreviousPapersState extends State<PreviousPapers> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ContentProvider contentProvider =
        Provider.of<ContentProvider>(context, listen: false);

    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, translate("Previous_Papers")),
      backgroundColor: Color(0xFFF1F3F8),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(
                  Icons.list_alt,
                  size: 50,
                ),
                title: Text(
                  contentProvider.contentModel.papers[index].title
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  contentProvider.contentModel.papers[index].detail,
                  style: TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviousPapersLoadingScreen(
                        fileURL:
                            contentProvider.contentModel.papers[index].filepath,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        itemCount: contentProvider.contentModel.papers.length,
      ),
    );
  }
}
