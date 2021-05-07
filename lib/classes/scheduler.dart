import 'package:cron/cron.dart';

class Scheduler {
  void functionname() {
    final cron = Cron();
    cron.schedule(
      Schedule.parse('*/3 * * * *'),
      () async {
        print('every three minutes');
      },
    );
    cron.schedule(
      Schedule.parse('8-11 * * * *'),
      () async {
        print('between every 8 and 11 minutes');
      },
    );
  }
}
