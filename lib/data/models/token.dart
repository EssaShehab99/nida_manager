import 'package:cloud_firestore/cloud_firestore.dart';

class Token {
  final String? token;
  final DateTime date;
  DocumentReference? reference;
  Token({required this.token, required this.date});

  factory Token.fromJson(Map<String, dynamic> json) =>
      Token(token: json["token"], date: (json["date"]??Timestamp.now()).toDate());

  Map<String, dynamic> toJson() => <String, dynamic>{
        "token": token,
        "date": FieldValue.serverTimestamp(),
      };
  factory Token.fromSnapshot(DocumentSnapshot snapshot) {
    final help = Token.fromJson(snapshot.data() as
    Map<String, dynamic>);
    help.reference = snapshot.reference;
    return help;
  }

}
