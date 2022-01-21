import 'package:firebase_database/firebase_database.dart';

class Message {
  Message({
    required this.id,
    required this.title,
    required this.body,
    required this.read,
    required this.timestamp,
  });

  String id;
  String title;
  String body;
  bool read;
  int timestamp;

  factory Message.fromRTDB(DataSnapshot snapshot) {
    var map = Map<String, dynamic>.from(snapshot.value as Map);
    return Message(
      id: snapshot.key ?? '0',
      title: map['title'] as String,
      body: map['body'] as String,
      read: map['read'] as bool,
      timestamp: map['timestamp'] as int,
    );
  }
}
