import 'package:meta/meta.dart';

class Mobile {
  final int mobileId;
  final String mobileName;
  final String mobileDescription;

  const Mobile({
    @required this.mobileId,
    @required this.mobileName,
    @required this.mobileDescription,
  });

  static Mobile fromJson(json) => Mobile(
        mobileId: json['mobileId'],
        mobileName: json['mobileName'],
        mobileDescription: json['mobileDescription'],
      );
}
