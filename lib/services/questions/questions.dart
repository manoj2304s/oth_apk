import 'package:cloud_firestore/cloud_firestore.dart';

var questionCollection = FirebaseFirestore.instance.collection('questions');

Future<dynamic> getAllQuestions() async {
  var querySnapshot = await questionCollection.get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}
