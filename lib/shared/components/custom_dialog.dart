import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/shared/components/custom_button.dart';

import '../../constants/constants_values.dart';
import '../../styles/colors.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key,required this.context,this.title,this.details}) : super(key: key);
final BuildContext context;
final String? title;
final String? details;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ConstantsValue.padding),
      ),
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Container(
            alignment: Alignment.center,
            height: 70,decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(ConstantsValue.radius))
          ),
            child: Text(title??'',style: Theme.of(context).textTheme.headline4),
          )),
          Flexible(child: Container(
            padding: EdgeInsets.all(ConstantsValue.padding),
            height: 250,decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(ConstantsValue.radius))
          ),
            child: Column(
              children: [
                Expanded(child: Text(details??'',style: Theme.of(context).textTheme.headline3,textAlign: TextAlign.justify)),
                Expanded(flex: 0,child: Container(height: 50,width: 200,alignment: Alignment.bottomCenter,child: CustomButton(text: "ok".tr(),onTap: (){
                  Navigator.of(this.context).pop();

                },)))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
