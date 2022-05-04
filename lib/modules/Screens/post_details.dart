import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/data/providers/post_add_manager.dart';
import 'package:provider/provider.dart';
import '../../data/network/post_dao.dart';
import '../../shared/components/components.dart';
import '/constants/constants_values.dart';
import '/data/models/post.dart';
import '/data/setting/app_pages.dart';
import '/styles/colors.dart';
import 'package:share_plus/share_plus.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({Key? key, required this.post}) : super(key: key);

  static MaterialPage page(Post post) {
    return MaterialPage(
        name: AppPages.postPath,
        key: const ValueKey(AppPages.postPath),
        child: PostDetails(
          post: post,
        ));
  }

  final Post post;

  @override
  Widget build(BuildContext context) {
    final postDao = Provider.of<PostDao>(context, listen: false);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding:
                  EdgeInsetsDirectional.only(start: ConstantsValue.padding),
              child: IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  )),
            ),
            backgroundColor: AppColors.primary,
            actions: [
              Padding(
                padding:
                    EdgeInsetsDirectional.only(end: ConstantsValue.padding),
                child: IconButton(
                    onPressed: () async {
                      Share.share(post.details);
                    },
                    icon: Icon(Icons.share, size: 25)),
              ),
              Padding(
                padding:
                    EdgeInsetsDirectional.only(end: ConstantsValue.padding),
                child: IconButton(
                    onPressed: () async {
                      Provider.of<PostAddManager>(context, listen: false)
                          .selectedPage(true, post: post,operationType: OperationType.EDIT);
                    },
                    icon: Icon(Icons.edit, size: 25)),
              ),
              Padding(
                padding:
                    EdgeInsetsDirectional.only(end: ConstantsValue.padding),
                child: IconButton(
                    onPressed: () async {
                      postDao.deletePost(post.id!).whenComplete(() {
                        snackBarMessage(
                            context, "delete-success".tr(), AppColors.green);
                      });
                    },
                    icon: Icon(Icons.delete, size: 25)),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(ConstantsValue.padding),
            child: SelectableText(post.details,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.justify),
          )),
    );
  }
}
