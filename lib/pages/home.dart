import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
//import 'package:move_to_background/move_to_background.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //MoveToBackground.moveTaskToBack();
        return false;
      },
      child: MaterialApp(
        home: Container(
          color: Colors.white,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Home page'),
                centerTitle: true,
                backgroundColor: Colors.blue,
              ),
              drawer: buildDrawer(context, HomePage.route),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.arrow_downward),
                onPressed: () {
                  //MoveToBackground.moveTaskToBack();
                },
              ),
              body: Center(
                child: Text('Press the floating action button'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void toggleListening() async {
  //   MoveToBackground.moveTaskToBack();
  // }
}
