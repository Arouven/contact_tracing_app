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
}
