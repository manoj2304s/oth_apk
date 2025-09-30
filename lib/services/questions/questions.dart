import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oth_apk/services/auth/updateUser.dart';
import 'package:get_storage/get_storage.dart';



/// Fetches the saved question time for the current user from Firestore.
Future<String?> fetchSavedQuestionTime() async {
  final store = GetStorage();
  var email = store.read('email');
  if (email == null) return null;
  final doc = await FirebaseFirestore.instance.collection('users').doc(email).get();
  if (doc.exists && doc.data() != null && doc.data()!.containsKey('questionTime')) {
    return doc.data()!['questionTime'] as String?;
  }
  return null;
}


var questionCollection = FirebaseFirestore.instance.collection('questions');

/// Saves the given time value to the current user's Firestore document under 'questionTime'.
Future<void> saveQuestionTime(String timeValue) async {
  await UpdateUsers(field: 'questionTime', value: timeValue);
}

Future<dynamic> getAllQuestions() async {
  var querySnapshot = await questionCollection.get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}
