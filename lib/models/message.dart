//import 'package:meta/meta.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class Message {
  final String title;
  final String body;

  const Message({
    required this.title,
    required this.body,
  });

  static Message fromListMessage(listMessage) => Message(
        title: listMessage.notification!.title!,
        body: listMessage.notification!.body!,
      );
}
