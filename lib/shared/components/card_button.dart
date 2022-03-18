import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/constants/constants_values.dart';
import '/styles/colors.dart';

class CardButton extends StatelessWidget {
  const CardButton({Key? key, required this.text,this.onTap}) : super(key: key);
  final String text;
  final  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ConstantsValue.padding),
        height: 200,
        child: Container(
          padding: EdgeInsets.all(ConstantsValue.padding),
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(ConstantsValue.radius)),
          child: Text(text,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              softWrap: true),
        ),
      ),
    );
  }
}
