import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:nida_manager/data/models/token.dart';

class TokenDao extends ChangeNotifier {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('token');

  Future<void> saveToken(String token) async {
    return collection
        .add({"token": token, "date": DateTime.now()}).then(
            (value) => null);
  }

  Future<List<Token>> getTokensSnapshot() async {
    List<Token> tokenList=[];

    await  collection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Token token = Token.fromSnapshot(doc);
        tokenList.add(token);
      });
    });
    return tokenList;
  }
}
