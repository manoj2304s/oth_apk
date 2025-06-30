import 'package:cloud_firestore/cloud_firestore.dart';

var storyCollection = FirebaseFirestore.instance.collection('story');

Future<String> getStory() async {
  var querySnapshot = await storyCollection.get();
  var storyString = querySnapshot.docs.first.data()['story'].toString();
  return storyString;
}
