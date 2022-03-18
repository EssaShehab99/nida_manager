import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '/data/models/post.dart';
class PostDao extends ChangeNotifier{
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('posts');

  Future<void>  savePost(Post post) async{
    return collection.add(post.toJson()).then((value) => null);
  }
  Stream<QuerySnapshot> getPostsStream() {
    return collection.orderBy("date",descending: true).snapshots();
  }
}
