import 'package:contact_tracing/pages/Location/live_geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
//import 'package:grouped_buttons/grouped_buttons.dart';

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
  List<String> _checked = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    print("in filter");
    super.initState();

    initCheckboxes().whenComplete(() {
      setState(() {});
    });
  }

  initCheckboxes() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('showConfirmInfected') == true) _checked.add("Infected");
    if (prefs.getBool('showContactWithInfected') == true)
      _checked.add("Contacts");
    if (prefs.getBool('showCleanUsers') == true) _checked.add("Safe users");
    if (prefs.getBool('showTestingCenters') == true)
      _checked.add("Testing Centers");
    if (prefs.getBool('showMyLocation') == true) _checked.add("Me");
  }

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
          checked: _checked,
          onChange: (bool isChecked, String label, int index) {
            if (label == "Infected") {
              prefs.setBool('showConfirmInfected', isChecked);
              print('showConfirmInfected');
            }
            if (label == "Contacts") {
              prefs.setBool('showContactWithInfected', isChecked);
              print('showContactWithInfected');
            }
            if (label == "Safe users") {
              prefs.setBool('showCleanUsers', isChecked);
              print('showCleanUsers');
            }
            if (label == "Testing Centers") {
              prefs.setBool('showTestingCenters', isChecked);
              print('showTestingCenters');
            }
            if (label == "Me") {
              prefs.setBool('showMyLocation', isChecked);
              print('showMyLocation');
            }
            setState(() {});
            print("isChecked: $isChecked   label: $label  index: $index");
          },
          onSelected: (List<String> checked) {
            print("checked: ${checked.toString()}");
            _checked = checked;
          },
        ),
      ],
    );
  }

  Widget _body() {
    return _popCheckboxes();
  }

  void backButton() {}

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
                    builder: (BuildContext context) => LiveGeolocatorPage(
                      downloadUpdatedLocations: false,
                    ),
                  ),
                );
              },
            ),
            title: Text('Marker Filter'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, FilterPage.route),
          body: _body(),
        ),
      ),
    );
  }
}
