import 'package:permission_handler/permission_handler.dart';

class ContactUtils {
  static Future<PermissionStatus> getContactPermission() async {
    final defaultPermission = await Permission.contacts.status;

    if (defaultPermission != PermissionStatus.granted &&
        defaultPermission != PermissionStatus.permanentlyDenied) {
      final newPermission = await Permission.contacts.request();

      return newPermission ?? PermissionStatus.undetermined;
    } else {
      return defaultPermission;
    }
  }
}
