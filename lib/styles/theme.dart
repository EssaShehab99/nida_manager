import 'package:flutter/material.dart';
import '/styles/colors.dart';

class AppTheme{
  static ThemeData light =ThemeData(
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.fromSwatch(
        accentColor:AppColors.primary, // but now it should be declared like this
      ),
    textTheme:  TextTheme(
      headline1: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColors.primary),
      headline2: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: AppColors.white,height: 1.4),
      headline3: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,color: AppColors.primary,height: 1.4),
      headline4: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: AppColors.white,height: 1.4)
    )
  );
}