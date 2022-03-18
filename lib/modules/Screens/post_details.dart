import 'package:flutter/material.dart';
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
