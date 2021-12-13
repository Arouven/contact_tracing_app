import 'package:contact_tracing/models/message.dart';

import 'notification.dart';

class ApiMessage {
  static getMessages() {
    print("in apiMessage, getMessages");
    try {
      final messages = Notif.notifications;
      //if (Notif.notifications.length > 0) {
      print('not null');
      return messages.map<Message>(Message.fromListMessage).toList();
      // }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
