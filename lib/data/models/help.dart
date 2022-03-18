import 'package:cloud_firestore/cloud_firestore.dart';

class Help {
  final String? id;
  final String? phone;
  final String title;
  final String details;
  DocumentReference? reference;
  Help({required this.id, required this.title, required this.details, required this.phone});

  factory Help.fromJson(Map<String, dynamic> json,String id) =>
      Help(id: id, title: json["title"], details: json["details"], phone: json["phone"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "title": title,
        "details": details,
        "phone": phone,
      };
  factory Help.fromSnapshot(DocumentSnapshot snapshot) {
    final help = Help.fromJson(snapshot.data() as
    Map<String, dynamic>,snapshot.id);
    help.reference = snapshot.reference;
    return help;
  }
}
