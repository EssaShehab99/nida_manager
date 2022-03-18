import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class ConstantsValue{
  static   late double padding;
  static   late double radius;
  static final List<String> drawerItems = ["about".tr(), "connect-us".tr()];

  ConstantsValue(BuildContext context){
    padding=20.0;
    radius=10.0;
  }
}