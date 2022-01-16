import 'dart:async';
import 'package:flutter/material.dart';

class Aesthetic {
  static Widget displayCircle() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Widget refreshButton({required BuildContext context, required route}) {
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

  static Widget displayProblemFirebase() {
    return Center(
      child: new Container(
        child: new Text(
          'Firebase problem!',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  static Widget displayNoConnection() {
    return Center(
      child: new Container(
        child: new Text(
          'No Internet!',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class DialogBox {
  static Future<void> showDiscardDialog(
      {context,
      String title = 'Discard',
      String body = 'Are you sure you want to discard changes made?',
      String buttonText = 'Discard',
      Color titleColor = Colors.red,
      route}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
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

  static Future<void> showErrorDialog({
    required BuildContext context,
    String title = 'Error',
    String body = 'An Error occur, please reload',
    Color titleColor = Colors.red,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
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
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> timedDialog({
    required BuildContext context,
    String title = 'time',
    String body = 'will automatically close',
    Color titleColor = Colors.green,
    required Duration autoCloseDuration,
  }) async {
    late Timer _timer;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        _timer = Timer(autoCloseDuration, () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
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
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }
}
