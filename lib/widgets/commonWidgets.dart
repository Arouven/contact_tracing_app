import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Aesthetic {
  static Widget displayCircle() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  // circleLoader() {
  //   return Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         SizedBox(
  //           height: MediaQuery.of(context).size.height / 1.3,
  //           child: Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         ),
  //         // Padding(
  //         //   //padding: EdgeInsets.only(top: 16),
  //         //   child:
  //        // Text('Awaiting result...'),
  //         // )
  //       ],
  //     ),
  //   );
  // }

  static Widget refreshButton({context, route}) {
    return Center(
      child: FloatingActionButton(
          foregroundColor: Colors.red,
          backgroundColor: Colors.white,
          child: Icon(Icons.replay),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => route,
            ));
          }),
    );
  }
}

class DialogBox {
  // static Future<bool> showAcceptDialog({
  //   context,
  //   String title = 'Save Changes',
  //   String body = 'Are you sure you want to save the new phone?',
  //   textbutton = 'Save',
  // }) async {
  //   showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           title,
  //           style: TextStyle(color: Colors.orange),
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               new Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(body),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text(textbutton),
  //             onPressed: () async {
  //               return true;
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  static Future<void> showDiscardDialog(
      {context,
      String title = 'Discard',
      String body = 'Are you sure you want to discard changes made?',
      String buttonText = 'Discard',
      route}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                new Row(
                  children: [
                    Expanded(
                      child: Text(body),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => route),
                    (e) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
