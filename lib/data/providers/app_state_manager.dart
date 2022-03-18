import 'package:flutter/cupertino.dart';


class AppStateManager extends ChangeNotifier{
  bool _initialized = false;

  bool get isInitialized => _initialized;

}