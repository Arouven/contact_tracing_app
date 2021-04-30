import 'package:permission_handler/permission_handler.dart';

class permissions {
  requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
    //await Geolocator.isLocationServiceEnabled();
    print(statuses);
  }
}
