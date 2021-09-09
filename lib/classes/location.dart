import 'package:meta/meta.dart';

class Location {
  final int locationId;
  final String locationName;
  final String locationDescription;
  final String locationNumber;

  const Location({
    @required this.locationId,
    @required this.locationName,
    @required this.locationDescription,
    @required this.locationNumber,
  });

  static Location fromJson(json) => Location(
      locationId: json['locationId'],
      locationName: json['locationName'],
      locationDescription: json['locationDescription'],
      locationNumber: json['locationNumber']);
  // static location newlocation() => location(
  //     locationId: 0,
  //     locationName: 'new location name',
  //     locationDescription: 'location description',
  //     locationNumber: '+230');
}
