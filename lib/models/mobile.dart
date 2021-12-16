//import 'package:meta/meta.dart';

class Mobile {
  final String mobileName;
  final String email;
  final String mobileNumber;
  final String fcmtoken;

  const Mobile({
    required this.mobileNumber,
    required this.mobileName,
    required this.email,
    required this.fcmtoken,
  });

  static Mobile fromJson(json) => Mobile(
        mobileName: json['mobileName'],
        email: json['email'],
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
