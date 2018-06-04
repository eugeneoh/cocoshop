import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _singleton = new FirestoreService._internal();
  final Firestore store = Firestore.instance;

  factory FirestoreService() {
    return _singleton;
  }

  FirestoreService._internal();
}