// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final store = GetStorage();

var usersCollection = FirebaseFirestore.instance.collection('users');

// ignore: non_constant_identifier_names
Future UpdateUsers(
    {required String field, required dynamic value}) async {
  try {
    var email = store.read('email');
    db.collection('users').doc(email).update({
      field: value 
    });
    
    return 'updated';
  } catch (e) {
    return e;
  }
}