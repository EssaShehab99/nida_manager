import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '/data/models/help.dart';
class HelpDao extends ChangeNotifier{
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('helps');

  Future<void> saveHelp(Help help) async {
 return collection.add(help.toJson()).then((value) => null);
  }
  Stream<QuerySnapshot> getHelpStream() {
    return collection.snapshots();
  }
}
