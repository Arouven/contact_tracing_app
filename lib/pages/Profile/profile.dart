import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

class ProfilePage extends StatefulWidget {
  static const String route = '/profile';

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var moblies = ApiProfile.getProfiles();
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profiles'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, ProfilePage.route),
          //body:
        ),
      ),
    );
  }
}
