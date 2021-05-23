import 'package:contact_tracing/classes/uploadClass.dart';
import 'package:cron/cron.dart';

class Scheduler {
  void cronFileUpload(String localFilePath) {
    final cron = Cron();
    cron.schedule(Schedule.parse('* */6 * * *'), () async {
      UploadFile uploadFile = new UploadFile();
      uploadFile.fileToUpload = localFilePath;
      uploadFile.uploadToServer();
    });
  }
}
