import 'package:meta/meta.dart';

class Mobile {
  final int mobileId;
  final String mobileName;
  final String mobileDescription;
  final String mobileNumber;

  const Mobile({
    @required this.mobileId,
    @required this.mobileName,
    @required this.mobileDescription,
    @required this.mobileNumber,
  });

  static Mobile fromJson(json) => Mobile(
      mobileId: json['mobileId'],
      mobileName: json['mobileName'],
      mobileDescription: json['mobileDescription'],
      mobileNumber: json['mobileNumber']);
}