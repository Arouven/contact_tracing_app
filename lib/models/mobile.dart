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
}
