import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserCredential? userCredential;
  DocumentSnapshot? documentSnapshot;

  //methods
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("Sign-in Error: $e");
      return null;
    }
  }

  Future<DocumentSnapshot?> getUserData(String uid, String collection) async {
    try {
      return await firestore.collection(collection).doc(uid).get();
    } catch (e) {
      print("User Data Error: $e");
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getSearchWithOne({
    required String searchedValue,
    required String collection,
    required String field,
  }) async {
    try {
      final snapshot = await firestore
          .collection(collection)
          .where(field, isEqualTo: searchedValue)
          .get();

      return snapshot.docs;
    } catch (e) {
      print("Search Error: $e");
      return [];
    }
  }

  Future<List<QueryDocumentSnapshot>> getSearchWithTwo({
    required String valueA,
    required String valueB,
    required String collection,
    required String fieldA,
    required String fieldB,
  }) async {
    try {
      final snapshot = await firestore
          .collection(collection)
          .where(fieldA, isEqualTo: valueA)
          .where(fieldB, isEqualTo: valueB)
          .get();

      return snapshot.docs;
    } catch (e) {
      print("Search Error: $e");
      return [];
    }
  }

  Future<bool> updateCollectionField({
    required String collection,
    required String document,
    required Map<String, dynamic> data,
  }) async {
    try {
      await firestore.collection(collection).doc(document).update(data);
      return true;
    } catch (e) {
      print("Update Error: $e");
      return false;
    }
  }
}
