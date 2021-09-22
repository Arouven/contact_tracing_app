import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/drawer.dart';

class FilterPage extends StatefulWidget {
  static const String route = '/filter';

  @override
  _FilterPageState createState() {
    return _FilterPageState();
  }
}

class _FilterPageState extends State<FilterPage> {
  // SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    // initCheckboxes().whenComplete(() {
    //   setState(() {});
    // });
  }

  // initCheckboxes() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  Widget _popCheckboxes() {
    return ListView(
      children: <Widget>[
        CheckboxGroup(
          labels: <String>[
            "Infected",
            "Contacts",
            "Safe users",
            "Testing Centers",
            "Me",
          ],
          //  checked: <String>[
          // prefs.getBool('showConfirmInfected') ? "Infected" : null,
          // prefs.getBool('showContactWithInfected') ? "Contacts" : null,
          // prefs.getBool('showCleanUsers') ? "Safe users" : null,
          // prefs.getBool('showTestingCenters') ? "Testing Centers" : null,
          // prefs.getBool('showMyLocation') ? "Me" : null,
          //  ],
          onChange: (bool isChecked, String label, int index) {
            // if (label == "Infected") {
            //   prefs.setBool('showConfirmInfected', isChecked);
            // }
            // if (label == "Contacts") {
            //   prefs.setBool('showContactWithInfected', isChecked);
            // }
            // if (label == "Safe users") {
            //   prefs.setBool('showCleanUsers', isChecked);
            // }
            // if (label == "Testing Centers") {
            //   prefs.setBool('showTestingCenters', isChecked);
            // }
            // if (label == "Me") {
            //   prefs.setBool('showMyLocation', isChecked);
            // }
            print("isChecked: $isChecked   label: $label  index: $index");
          },
          onSelected: (List<String> checked) =>
              print("checked: ${checked.toString()}"),
        ),
      ],
    );
  }

  Widget _body() {
    return _popCheckboxes();
  }

  void backButton() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: WillPopScope(
          onWillPop: backButton,
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: backButton,
              ),
              title: Text('Marker Filter'),
              centerTitle: true,
              backgroundColor: Colors.blue,
            ),
            drawer: buildDrawer(context, FilterPage.route),
            body: _body(),
          ),
        ),
      ),
    );
  }
}
