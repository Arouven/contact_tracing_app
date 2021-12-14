//import 'package:meta/meta.dart';

class Mobile {
  final int mobileId;
  final String mobileName;
  final String mobileDescription;
  final String mobileNumber;
  final String fcmtoken;

  const Mobile({
    required this.mobileId,
    required this.mobileName,
    required this.mobileDescription,
    required this.mobileNumber,
    required this.fcmtoken,
  });

  static Mobile fromJson(json) => Mobile(
        mobileId: json['mobileId'],
        mobileName: json['mobileName'],
        mobileDescription: json['mobileDescription'],
        mobileNumber: json['mobileNumber'],
        fcmtoken: json['fcmtoken'],
      );
  // static Mobile problem(non) => Mobile(
  //       mobileId: 0,
  //       mobileName: 'mobileName',
  //       mobileDescription: 'mobileDescription',
  //       mobileNumber: 'mobileNumber',
  //       fcmtoken: 'fcmtoken',
  //     );
  // static Mobile newmobile() => Mobile(
  //     mobileId: 0,
  //     mobileName: 'new mobile name',
  //     mobileDescription: 'mobile description',
  //     mobileNumber: '+230');
}
