import 'package:contact_tracing/classes/uploadClass.dart';
import 'package:cron/cron.dart';

class Scheduler {
  void cronFileUpload() {
    final cron = Cron();
    cron.schedule(Schedule.parse('*/2 * * * *'), () async {
      // to run every 6 hrs -- '* */6 * * *'
      UploadFile uploadFile = new UploadFile();
      uploadFile.uploadToServer();
    });
  }
}
