import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nida_manager/data/network/token_dao.dart';
import '/data/providers/post_add_manager.dart';
import '../../shared/components/components.dart';
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
  const PostAdd({Key? key, this.post,required this.operationType}) : super(key: key);

  static MaterialPage page(Post? post,OperationType operationType) {
    return MaterialPage(
        name: AppPages.postAddPath,
        key: ValueKey(AppPages.postAddPath),
        child: PostAdd(
          post: post,
          operationType: operationType,
        ));
  }

  final Post? post;
  final OperationType operationType;
  @override
  State<PostAdd> createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  late TextEditingController detailsController;
  late TextEditingController titleController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    detailsController = TextEditingController(text: widget.post?.details);
    titleController = TextEditingController();
    _formKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    detailsController.dispose();
    titleController.dispose();
    super.dispose();
  }

  Future<http.Response> sendNotification(
      List<String> tokenIdList, String heading, String contents) async {
    return await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic YThiOTM5MzYtMDk2NS00NjNlLWE4YzgtNWRkOGYyZThmYWI5',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "12205d7a-4f7a-48b0-a44c-ade73e73a3a5",
        "filters": [
          {"field": "tag", "key": "key", "relation": "is", "value": "value"},
        ],
        "data": {"foo": "bar"},
        "headings": {"en": heading},
        "contents": {"en": contents},
        "android_accent_color": "FF9976D2",
        "small_icon": "@mipmap/ic_launcher_round",
      }),
    );
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
                        hintText: 'subject'.tr(),
                        radius: ConstantsValue.radius * 2,
                        keyboardType: TextInputType.multiline,
                        controller: titleController,
                        maxLines: 1),
                    SizedBox(height: ConstantsValue.padding,),
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
                        text: widget.operationType==OperationType.ADD ? "send".tr() : "edit".tr(),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (!postAddManager.didHanging) {
                              if (widget.operationType==OperationType.ADD) {
                                postDao
                                    .savePost(
                                        Post(details: detailsController.text))
                                    .whenComplete(
                                  () {
                                    Provider.of<TokenDao>(context,listen: false)
                                        .getTokensSnapshot()
                                        .then((value) {
                                      List<String> tokenList = [];
                                      if (value != [])
                                        value.forEach((element) {
                                          tokenList.add(element.token!);
                                        });
                                      sendNotification(tokenList, titleController.text,
                                          detailsController.text);
                                    });
                                    snackBarMessage(context,
                                        "post-success".tr(), AppColors.green);
                                    postAddManager.handle();
                                  },
                                );
                              } else {
                                postDao
                                    .editPost(Post(
                                        id: widget.post!.id,
                                        details: detailsController.text))
                                    .whenComplete(
                                  () {
                                    snackBarMessage(context,
                                        "edit-success".tr(), AppColors.green);
                                    postAddManager.handle();
                                  },
                                );
                              }
                            } else {
                              snackBarMessage(
                                  context,
                                  "await".tr() +
                                      " ${postAddManager.seconds} " +
                                      "second".tr(),
                                  AppColors.primary);
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
