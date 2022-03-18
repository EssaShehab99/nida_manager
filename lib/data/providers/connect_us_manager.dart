import 'dart:async';

import 'package:flutter/cupertino.dart';

class ConnectUsManager extends ChangeNotifier{
  bool _didSelectedPage = false;
  bool _didHanging = false;

bool get didSelectedPage=>_didSelectedPage;
bool get didHanging=>_didHanging;
  void selectedPage(bool selected) {
    _didSelectedPage = selected;
    notifyListeners();
  }
  void handle(){
    _didHanging=true;
    Timer(Duration(seconds: 30), () {
      _didHanging=false;
    },);
  }
}