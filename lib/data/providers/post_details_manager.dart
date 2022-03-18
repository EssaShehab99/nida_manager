import 'package:flutter/cupertino.dart';
import '/data/models/post.dart';

class PostDetailsManager extends ChangeNotifier{
  bool _didSelectedPage = false;
  Post? _post;

  Post? get post=>_post;

  bool get didSelectedPage=>_didSelectedPage;

  void selectedPage(bool selected, {Post? post}) {

    _didSelectedPage = selected;
    if(post!=null) {
      _post=post;
    }
    notifyListeners();
  }
}