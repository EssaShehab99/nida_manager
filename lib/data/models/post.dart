import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String details;
  final DateTime? date;
  DocumentReference? reference;
  Post({this.id, required this.details, this.date});

  factory Post.fromJson(Map<String, dynamic> json,String id) =>
      Post(id: id, details: json["details"]??"", date: (json["date"]??Timestamp.now()).toDate());

  Map<String, dynamic> toJson() => <String, dynamic>{
    "date": FieldValue.serverTimestamp(),
    "details": details,
  };
  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    final post = Post.fromJson(snapshot.data() as
    Map<String, dynamic>,snapshot.id);
    post.reference = snapshot.reference;
    return post;
  }
}
