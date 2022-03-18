import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nida_manager/data/providers/post_add_manager.dart';
import '/data/models/help.dart';
import '/data/models/post.dart';
import '/data/network/help_dao.dart';
import '/data/network/post_dao.dart';
import '/data/setting/app_pages.dart';
import '/shared/components/custom_button.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_values.dart';
import '../../data/providers/connect_us_manager.dart';
import '../../styles/colors.dart';

class PostAdd extends StatefulWidget {
  const PostAdd({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
        name: AppPages.postAddPath,
        key: ValueKey(AppPages.postAddPath),
        child: PostAdd());
  }

  @override
  State<PostAdd> createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  late TextEditingController detailsController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    detailsController = TextEditingController();
    _formKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postDao = Provider.of<PostDao>(context, listen: false);
    final postAddManager = Provider.of<PostAddManager>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsetsDirectional.only(start: ConstantsValue.padding),
            child: IconButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                )),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                AppColors.white,
                AppColors.primary,
              ])),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ConstantsValue.padding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextFormField(
                        textInputAction: TextInputAction.done,
                        context: context,
                        hintText: 'details'.tr(),
                        radius: ConstantsValue.radius * 2,
                        keyboardType: TextInputType.multiline,
                        controller: detailsController,
                        maxLines: 5),
                    SizedBox(
                      height: ConstantsValue.padding,
                    ),
                    Container(
                      height: 65,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ConstantsValue.radius * 5),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.shadow.withOpacity(0.5),
                                spreadRadius: 0.0,
                                offset: const Offset(0, 1),
                                blurRadius: 5)
                          ]),
                      child: CustomButton(
                        text: "send".tr(),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if(!postAddManager.didHanging) {
                              postDao.savePost(Post(details: detailsController.text)).whenComplete(() {
                                snackBarMessage(context,"post-success".tr(),AppColors.green);
                                postAddManager.handle();
                              },);
                            }else {
                              snackBarMessage(context,"await".tr(),AppColors.primary);
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void snackBarMessage(BuildContext context,String text,Color? color) {
     ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Text(text),backgroundColor: color),
                                );
  }

  TextFormField buildTextFormField(
      {String? hintText,
      TextInputType? keyboardType,
      int? maxLines,
      TextInputAction? textInputAction,
      double? radius,
      required BuildContext context,
      TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'validate'.tr();
        }
        return null;
      },
      autofocus: false,
      decoration: InputDecoration(
        fillColor: AppColors.white,
        filled: true,
        hintText: hintText,
        contentPadding: EdgeInsets.all(ConstantsValue.padding * 0.8),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(radius ?? ConstantsValue.radius * 5),
          borderSide: const BorderSide(),
        ),
        enabledBorder: buildOutlineInputBorder(radius),
        focusedBorder: buildOutlineInputBorder(radius),
        errorBorder: buildOutlineInputBorder(radius),
        disabledBorder: buildOutlineInputBorder(radius),
        focusedErrorBorder: buildOutlineInputBorder(radius),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(double? radius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius ?? ConstantsValue.radius * 5),
      borderSide: BorderSide(color: AppColors.white.withOpacity(0.0)),
    );
  }
}