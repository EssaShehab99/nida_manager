import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? id;
  final String? title;
  final String details;
  final DateTime? date;
  DocumentReference? reference;
  Post({this.id, this.title, required this.details, this.date});

  factory Post.fromJson(Map<String, dynamic> json,String id) =>
      Post(id: id, title: json["title"]??"", details: json["details"]??"", date: (json["date"] as Timestamp).toDate());

  Map<String, dynamic> toJson() => <String, dynamic>{
    "title": title,
    "details": details,
    "date": FieldValue.serverTimestamp(),
  };
  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    final post = Post.fromJson(snapshot.data() as
    Map<String, dynamic>,snapshot.id);
    post.reference = snapshot.reference;
    return post;
  }
}
