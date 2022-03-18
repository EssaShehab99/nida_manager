import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '/data/models/post.dart';
class PostDao extends ChangeNotifier{
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('posts');

  Stream<QuerySnapshot> getPostsStream() {
    return collection.orderBy("date",descending: true).snapshots();
  }
  Future<void>  savePost(Post post) async{
    return collection.add(post.toJson()).then((value) => null);
  }
  Future<void>  editPost(Post post) async{
    return collection.doc(post.id).update(post.toJson()).then((value) => null);
  }
  Future<void>  deletePost(String id) async{
    return collection.doc(id).delete().then((value) => null);
  }
}
