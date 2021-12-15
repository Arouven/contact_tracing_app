import 'package:contact_tracing/models/message.dart';
import 'package:contact_tracing/pages/Notification/notifications.dart';
import 'package:contact_tracing/services/badgeservices.dart';
import 'package:contact_tracing/services/databaseServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';
import 'package:firebase_database/firebase_database.dart';

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
  bool _isLoading = true;
  @override
  void initState() {
    //FlutterBackgroundService().sendData({"action": "updateBadge"});
    // getListofMessages().then((value) => setState(() {}));
    // updateListofMessages();
    super.initState();
  }

  Widget _body() {
    final messageid = widget.message.id;
    final messagetitle = widget.message.title;
    final messagebody = widget.message.body;
    final messagetimestamp = widget.message.timestamp;
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scrollbar(
        child: Container(),
        
        // ListView.builder(
        //   itemCount: messageList.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return ListTile(
        //       leading: Icon(Icons.email),
        //       title: Text(
        //         messageList[index].title,
        //         style: (messageList[index].read)
        //             ? null
        //             : TextStyle(
        //                 fontWeight: FontWeight.bold,
        //               ),
        //       ),
        //       trailing: (messageList[index].read)
        //           ? null
        //           : Icon(
        //               Icons.brightness_1,
        //               size: 9.0,
        //               color: Colors.red,
        //             ),
        //       onTap: () async {
        //         if (messageList[index].read) {
        //         } else {
        //           await DatabaseServices().markRead(
        //             message: messageList[index],
        //             path: path,
        //           );
        //           BadgeServices.number = BadgeServices.number - 1;
        //           BadgeServices.updateAppBadge();
        //         }
        //         Navigator.of(context).pushReplacement(MaterialPageRoute(
        //           builder: (BuildContext context) => MobilePage(),
        //         ));
        //       },
        //     );
        //   },
        // ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => NotificationsPage(),
                  ),
                );
              },
            ),
            title: Text('Notification'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, NotificationsPage.route),
          body: _body(),
        ),
      ),
    );
  }
}
