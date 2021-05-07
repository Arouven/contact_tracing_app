import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: MaterialApp(
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_downward),
            onPressed: () {
              MoveToBackground.moveTaskToBack();
            },
          ),
          appBar: AppBar(
            title: const Text('MoveToBackground Example'),
          ),
          body: Center(
            child: Text('Press the floating action button'),
          ),
        ),
      ),
    );
  }

  void toggleListening() async {
    MoveToBackground.moveTaskToBack();
  }
}
