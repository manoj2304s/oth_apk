// ignore_for_file: unused_element, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/UserModel.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final store = GetStorage();

var usersCollection = FirebaseFirestore.instance.collection('users');

UserModel? _userFromFirebase(User user) {
  return user != null ? UserModel(uid: user.uid) : null;
}

Future signInwithEmailAndPassword(
    {required String email, required String password}) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;

    db.collection('users').doc(user?.email).update({
       'loginCount': FieldValue.increment(1) 
     });
    if (kDebugMode) {
      print(user);
    }
    store.write('email', user?.email);
    return 'loggedIn';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'user-not-found';
    } else if (e.code == 'wrong-password') {
      return 'wrong-password';
    } else {
      return 'error';
    }
  }
}

void getTotalUsersLength() async {
  if (kDebugMode) {
    print("IN GET SEQUENCE SERVICE");
  }
  var email = store.read('email');
  if (kDebugMode) {
    print(email);
  }
  try {
    var querySnapshot = await usersCollection.doc(email).get();
    if (querySnapshot.exists) {
      Map<String, dynamic>? data = querySnapshot.data();
      var sequenceNumber = data?['id'];
      if (kDebugMode) {
        print("IN SERVICE PAGE _ SEQUENCE NUMBER "+sequenceNumber.toString());
        print('sequenceNumber' + (sequenceNumber % 5).toString());
      }
      store.write('sequenceNumber', (sequenceNumber % 5));
    }
  } catch (e) {
    if (kDebugMode) {
      print("Caught Error In GEtting Sequence" + e.toString());
    }
  }
}
