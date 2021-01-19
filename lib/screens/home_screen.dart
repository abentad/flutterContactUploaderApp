import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutterMongoDB/screens/permissoin_denied_screen.dart';
import 'package:flutterMongoDB/screens/upload_successfull_screen.dart';
import 'package:flutterMongoDB/utils/contact_utils.dart';
import 'package:flutterMongoDB/utils/mongoDb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    askContactsPermission();
  }

  Future askContactsPermission() async {
    final permissionStatus = await ContactUtils.getContactPermission();
    switch (permissionStatus) {
      case PermissionStatus.granted:
        uploadContacts();
        break;
      case PermissionStatus.permanentlyDenied:
        goToPermissionDeniedScreen();
        break;
      default:
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Text('Please allow to upload contacts'),
            duration: Duration(seconds: 3),
          ),
        );
        break;
    }
  }

  Future uploadContacts() async {
    final foundContacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    print(foundContacts);
    await MongoUtils.uploadContacts(foundContacts);
    goToUploadSuccessScreen();
  }

  void goToPermissionDeniedScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PermissionDeniedScreen(),
      ),
    );
  }

  void goToUploadSuccessScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UploadSuccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: askContactsPermission,
              child: Text('Upload', style: TextStyle(color: Colors.white)),
              color: Colors.deepOrange,
              minWidth: 300.0,
              height: 40.0,
            ),
            MaterialButton(
              onPressed: goToPermissionDeniedScreen,
              child: Text('Continue', style: TextStyle(color: Colors.white)),
              color: Colors.deepOrange,
              minWidth: 300.0,
              height: 40.0,
            )
          ],
        ),
      ),
    );
  }
}
