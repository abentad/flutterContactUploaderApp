import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoUtils {
  static void connectToDb() async {
    //adds new item
    // await coll.insert({'name': 'Nathan'});
    //prints all items insidet the collection
    // print(await coll.find().toList());
  }

  static Future uploadContacts(List<Contact> contacts) async {
    final contactsJson = contacts.map((contact) => contact.toMap()).toList();

    // final jsonContact = jsonDecode(contactsJson.toString());

    final dbName = 'contacts';
    final db = await Db.create(
        'mongodb+srv://Ab:19875321ab@restapi.dgg3t.mongodb.net/$dbName?retryWrites=true&w=majority');
    //opens the db that we connected to
    await db.open();
    //creates a coll variable that represents the collection inside the db
    final coll = db.collection('contactscoll');
    print(contactsJson);
    // print('second');
    // print(jsonContact);
    await coll.insert({"name": "Abenezer", "contacts": contactsJson});
  }
}

// await usersCollection.insertAll([
//   {'login': 'jdoe', 'name': 'John Doe', 'email': 'john@doe.com'},
//   {'login': 'lsmith', 'name': 'Lucy Smith', 'email': 'lucy@smith.com'}
// ]);

//students.remove();
