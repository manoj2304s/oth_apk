import 'package:cloud_firestore/cloud_firestore.dart';

var placesCollection = FirebaseFirestore.instance.collection('places');

Future<dynamic> getLocation(id) async {
  var querySnapshot = await placesCollection.doc(id).get();
  if (querySnapshot.exists) {
    return querySnapshot.data();
  } else {
    return null;
  }
}
