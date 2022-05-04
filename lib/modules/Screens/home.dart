import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/providers/post_add_manager.dart';
import '../../shared/components/components.dart';
import '/constants/constants_images.dart';
import '/constants/constants_values.dart';
import '/data/network/post_dao.dart';
import '/data/providers/connect_us_manager.dart';
import '/data/providers/post_details_manager.dart';
import '/shared/components/card_button.dart';
import '/shared/components/custom_dialog.dart';
import '/styles/colors.dart';
import 'package:provider/provider.dart';

import '../../data/models/post.dart';
import '../../data/setting/app_pages.dart';
import '../../shared/icons/app_icons.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  static MaterialPage page() {
    return MaterialPage(
        name: AppPages.homePath,
        key: const ValueKey(AppPages.homePath),
        child: Home());
  }
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        body: Column(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                height: 56,
                padding:
                    EdgeInsets.symmetric(horizontal: ConstantsValue.padding),
                decoration: BoxDecoration(color: AppColors.primary, boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      spreadRadius: 0.0,
                      offset: Offset(0, 1),
                      blurRadius: 5)
                ]),
                child: Row(
                  children: [
                    Expanded(
                        child: IconButton(
                            onPressed: () => _key.currentState?.openDrawer(),
                            alignment: AlignmentDirectional.centerStart,
                            icon: Transform.rotate(
                                angle: isRTL(context) ? 3.15 : 0,
                                child: Icon(
                                  AppIcons.menu,
                                  color: AppColors.white,
                                  size: 20,
                                )))),
                    Expanded(
                        child: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            child: SvgPicture.asset(
                              ConstantsImages.logo,
                              height: 40,
                              width: 40,
                            )))
                  ],
                ),
              ),
            ),
            Expanded(
                child: RefreshIndicator(
                  key: refreshKey,
                  onRefresh: () async{

                  },
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Provider.of<PostDao>(context).getPostsStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildList(snapshot.data!.docs);
                    },
                  ),
                ))
          ],
        ),
        drawer: ClipRRect(
          borderRadius: BorderRadius.horizontal(
              left: isRTL(context)
                  ? Radius.circular(ConstantsValue.radius * 4.5)
                  : Radius.zero,
              right: isRTL(context)
                  ? Radius.zero
                  : Radius.circular(ConstantsValue.radius * 4.5)),
          child: Drawer(
            backgroundColor: AppColors.primary,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: LayoutBuilder(
                      builder: (context, constraints) => SvgPicture.asset(
                            ConstantsImages.logo,
                            height: constraints.maxHeight * 0.8,
                          )),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadiusDirectional.only(
                              topEnd:
                                  Radius.circular(ConstantsValue.radius * 10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var item in ConstantsValue.drawerItems)
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  if (ConstantsValue.drawerItems.indexOf(item) == 0) {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => CustomDialog(
                                              title: "nida".tr(),
                                              details: "about-nida".tr(),
                                              context: ctx,
                                            ));
                                  } else {
                                    Provider.of<ConnectUsManager>(context,
                                            listen: false)
                                        .selectedPage(true);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: ConstantsValue.padding,
                                      vertical: ConstantsValue.padding * 0.5),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: AppColors.primary,
                                              width: 2))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.home,
                                            color: AppColors.primary,
                                            size: 30,
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                ConstantsValue.padding * 0.5),
                                            child: Text(
                                              item,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1,
                                            ),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 30,
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            child: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              color: AppColors.primary,
                                              size: 25,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: (){
            Provider.of<PostAddManager>(context, listen: false)
                .selectedPage(true,operationType: OperationType.ADD);

          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
  Widget _buildList(List<DocumentSnapshot>? snapshot) {
    return ListView.builder(

      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics (),
      padding: const EdgeInsets.only(top: 20.0),
      itemCount: snapshot?.length,
     itemBuilder:  (ctx,index)=>_buildListItem(ctx, snapshot![index]),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final post = Post.fromSnapshot(snapshot);
    return CardButton(
        text: post.details,
        onTap: () {
          Provider.of<PostDetailsManager>(context, listen: false)
              .selectedPage(true, post: post);
        });
  }
  bool isRTL(BuildContext context) => Directionality.of(context)
      .toString()
      .contains(TextDirection.RTL.value.toLowerCase());
}
