import 'dart:async';

import 'package:flutter/cupertino.dart';
import '/data/models/post.dart';

class PostAddManager extends ChangeNotifier{
  bool _didSelectedPage = false;
  Post? _post;
  bool _didHanging = false;
  int seconds = 5;

  Post? get post=>_post;

  bool get didSelectedPage=>_didSelectedPage;
  bool get didHanging=>_didHanging;

  void selectedPage(bool selected, {Post? post}) {

    _didSelectedPage = selected;
    if(post!=null) {
      _post=post;
    }
    notifyListeners();
  }
  void handle(){
    _didHanging=true;
    Timer(Duration(seconds: seconds), () {
      _didHanging=false;
    },);
  }
}