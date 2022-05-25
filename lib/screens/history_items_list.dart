import 'package:cached_network_image/cached_network_image.dart';
import 'package:ofledn/localization/language_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../common/apidata.dart';
import '../model/purchase_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'invoice_loading_screen.dart';

class HistoryItemsList extends StatelessWidget {
  Widget itemTab(Orderhistory order, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Purchase Id :-> ${order.id}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvoiceLoadingScreen(order.id)));
      },
      child: Container(
        height: 210,
        padding:
            EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              height: 65,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: order.courses == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                  "assets/placeholder/searchplaceholder.png"),
                            )
                          : CachedNetworkImage(
                              imageUrl: APIData.courseImages +
                                  "${order.courses.previewImage}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.asset(
                                    "assets/placeholder/new_course.png"),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            order.courses != null
                                ? "${order.courses.title}"
                                : translate("Bundle_Course"),
                            maxLines: 2,
                            style: TextStyle(
                                color: Color(0xFF586474),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    translate("Start_"),
                    style: TextStyle(
                      fontFamily: 'Mada',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF586474),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    order.enrollStart == null
                        ? "NA"
                        : "${DateFormat.yMMMd().format(order.enrollStart)}",
                    style: new TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Mada',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284A2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    translate("End_"),
                    style: TextStyle(
                      fontFamily: 'Mada',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF586474),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                      order.enrollExpire == null
                          ? "NA"
                          : "${DateFormat.yMMMd().format(order.enrollExpire)}",
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Mada',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0284A2))),
                ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                order.totalAmount == null
                    ? SizedBox.shrink()
                    : Expanded(
                        flex: 2,
                        child: Text(
                          translate("Amount_"),
                          style: TextStyle(
                            fontFamily: 'Mada',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF586474),
                          ),
                        ),
                      ),
                Expanded(
                  flex: 3,
                  child: order.totalAmount == null
                      ? SizedBox.shrink()
                      : Text(
                          "${order.totalAmount} ${order.currency} ",
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Mada',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0284A2),
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                order.totalAmount == null
                    ? SizedBox.shrink()
                    : Expanded(
                        flex: 2,
                        child: Text(
                          translate("Transaction_Id"),
                          style: TextStyle(
                            fontFamily: 'Mada',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF586474),
                          ),
                        ),
                      ),
                Expanded(
                  flex: 3,
                  child: order.transactionId == null
                      ? SizedBox.shrink()
                      : Text(
                          "${order.transactionId} By ${order.paymentMethod} ",
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Mada',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0284A2),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget whenNull() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 180,
                width: 180,
                child: Image.asset("assets/images/emptycategory.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    translate("No_History"),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      translate("Looks_like_no_purchase_history_available"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LanguageProvider languageProvider;

  @override
  Widget build(BuildContext context) {
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    List<Orderhistory> purchaseHistory =
        Provider.of<List<Orderhistory>>(context);
    if (purchaseHistory != null)
      purchaseHistory = purchaseHistory.reversed.toList();
    return Scaffold(
      backgroundColor: Color(0xFFF1F3F8),
      body: (purchaseHistory == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xFF0284A2)),
              ),
            )
          : purchaseHistory.length == 0
              ? whenNull()
              : ListView.builder(
                  itemCount: purchaseHistory.length,
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  itemBuilder: (BuildContext context, int index) {
                    return itemTab(purchaseHistory[index], context);
                  }),
    );
  }
}
