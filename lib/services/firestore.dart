import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference descCollection =
  FirebaseFirestore.instance.collection('description');

  Future updatePostData(String desc) async {
    return await descCollection.add({
      'desc': desc,
    });
  }
}