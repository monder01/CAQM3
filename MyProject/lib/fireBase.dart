import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserCredential? userCredential;
  DocumentSnapshot? documentSnapshot;

  //methods
  Future<UserCredential?> signIn(String email, String password) async {
    userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  Future<DocumentSnapshot?> getUserData(String uid) async {
    documentSnapshot = await firestore.collection("users").doc(uid).get();
    return documentSnapshot;
  }

  Future<List<QueryDocumentSnapshot>> getSearchWithOne(
    String searchedWith,
    String collectionA,
    String collectionB,
  ) async {
    final snapshot = await firestore
        .collection(collectionA)
        .where(collectionB, isEqualTo: searchedWith)
        .get();
    return snapshot.docs;
  }
}
