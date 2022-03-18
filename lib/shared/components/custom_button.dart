import 'package:flutter/material.dart';
import '/constants/constants_values.dart';
import '/styles/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key,required this.text, this.onTap}) : super(key: key);
final String text;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(ConstantsValue.padding*5)
        ),
        height: 55,
        child: Text(text,style: Theme.of(context).textTheme.headline4?.copyWith(
          fontSize: 18
        )),
      ),
    );
  }
}
