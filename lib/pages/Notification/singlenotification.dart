import 'package:contact_tracing/main.dart';
import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/pages/Notification/notifications.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';

class SingleNotificationPage extends StatefulWidget {
  static const String route = '/singlenotif';
  final Message message;

  const SingleNotificationPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  _SingleNotificationPageState createState() {
    return _SingleNotificationPageState();
  }
}

class _SingleNotificationPageState extends State<SingleNotificationPage> {
  Widget _body() {
    final messageid = widget.message.id;
    final messagetitle = widget.message.title;
    final messagebody = widget.message.body;
    final messagetimestamp = widget.message.timestamp;
    var humanReadableTimeStamp =
        (DateTime.fromMillisecondsSinceEpoch(messagetimestamp * 1000))
            .toLocal()
            .toString();
    humanReadableTimeStamp = humanReadableTimeStamp.substring(
      0,
      humanReadableTimeStamp.length - 4,
    );
    //var testText = lipsum.createText(numParagraphs: 10, numSentences: 5);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  messagetitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(humanReadableTimeStamp),
            ],
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(8.0),
              child: Text(
                messagebody,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _markRead() async {
    if (widget.message.read == false) {
      await DatabaseFirebaseServices.markRead(
        message: widget.message,
        path: path,
      );
      BadgeServices.number = BadgeServices.number - 1;
      BadgeServices.updateAppBadge();
    }
  }

  @override
  void initState() {
    _markRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => NotificationsPage(),
                //   ),
                // );
              },
            ),
            title: Text('Notification'),
            centerTitle: true,
            // backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, NotificationsPage.route),
          body: _body(),
        ),
      ),
    );
  }
}
