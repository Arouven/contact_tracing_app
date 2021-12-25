import 'package:contact_tracing/pages/Location/live_geolocator.dart';
import 'package:contact_tracing/services/globals.dart';
import 'package:contact_tracing/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class FilterPage extends StatefulWidget {
  static const String route = '/filter';

  @override
  _FilterPageState createState() {
    return _FilterPageState();
  }
}

class _FilterPageState extends State<FilterPage> {
  List<String> _checked = [];

  @override
  void initState() {
    print("in filter");
    super.initState();

    initCheckboxes().whenComplete(() {
      setState(() {});
    });
  }

  initCheckboxes() async {
    if (await GlobalVariables.getShowConfirmInfected() == true)
      _checked.add("Infected");
    if (await GlobalVariables.getShowContactWithInfected() == true)
      _checked.add("Contacts");
    if (await GlobalVariables.getShowCleanUsers() == true)
      _checked.add("Safe users");
    if (await GlobalVariables.getShowTestingCenters() == true)
      _checked.add("Testing Centers");
    if (await GlobalVariables.getShowMyLocation() == true) _checked.add("Me");
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
          onChange: (bool isChecked, String label, int index) async {
            if (label == "Infected") {
              await GlobalVariables.setShowConfirmInfected(
                  showConfirmInfected: isChecked);
              print('showConfirmInfected');
            }
            if (label == "Contacts") {
              await GlobalVariables.setShowContactWithInfected(
                  showContactWithInfected: isChecked);
              print('showContactWithInfected');
            }
            if (label == "Safe users") {
              await GlobalVariables.setShowCleanUsers(
                  showCleanUsers: isChecked);
              print('showCleanUsers');
            }
            if (label == "Testing Centers") {
              await GlobalVariables.setShowTestingCenters(
                  showTestingCenters: isChecked);
              print('showTestingCenters');
            }
            if (label == "Me") {
              await GlobalVariables.setShowMyLocation(
                  showMyLocation: isChecked);
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
      //  color: Colors.white,
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
            // backgroundColor: Colors.blue,
          ),
          drawer: buildDrawer(context, FilterPage.route),
          body: _body(),
        ),
      ),
    );
  }
}
