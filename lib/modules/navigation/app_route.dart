import 'package:flutter/cupertino.dart';
import '../../shared/components/components.dart';
import '/modules/Screens/post_add.dart';
import '../../data/providers/post_add_manager.dart';
import '/modules/navigation/custom_transition_delegate.dart';
import '/modules/Screens/connect_us.dart';
import '/modules/Screens/post_details.dart';

import '../../data/providers/app_state_manager.dart';
import '../../data/providers/connect_us_manager.dart';
import '../../data/providers/post_details_manager.dart';
import '../../data/providers/home_manager.dart';
import '../../data/setting/app_pages.dart';
import '../Screens/home.dart';
import 'app_link.dart';


class AppRoute extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  final HomeManager homeManager;
  final PostDetailsManager postDetailsManager;
  final PostAddManager postAddManager;
  final ConnectUsManager connectUsManager;

  AppRoute({
    required this.appStateManager,
    required this.homeManager,
    required this.postDetailsManager,
    required this.connectUsManager,
    required this.postAddManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    homeManager.addListener(notifyListeners);
    postDetailsManager.addListener(notifyListeners);
    connectUsManager.addListener(notifyListeners);
    postAddManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    homeManager.removeListener(notifyListeners);
    postDetailsManager.removeListener(notifyListeners);
    connectUsManager.removeListener(notifyListeners);
    postAddManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      transitionDelegate: CustomTransitionDelegate(),
      pages: [
       ...[
          Home.page(),
          if(postDetailsManager.didSelectedPage)
            PostDetails.page(postDetailsManager.post!),
           if(connectUsManager.didSelectedPage)
            ConnectUs.page(),
           if(postAddManager.didSelectedPage)
            PostAdd.page(postAddManager.post,postAddManager.operationType)
        ]
      ],
    );
  }

  @override
  AppLink get currentConfiguration => getCurrentPath();

  AppLink getCurrentPath() {
    if (postDetailsManager.didSelectedPage) {
      final id = postDetailsManager.post?.id;
      return AppLink(location: AppLink.kPostPath, postId: id);
    } else if (connectUsManager.didSelectedPage) {
      return AppLink(location: AppLink.kConnectUsPath);
    } else if (homeManager.didSelectedPage) {
      return AppLink(location: AppLink.kHomePath);
    }else if (postAddManager.didSelectedPage) {
      return AppLink(location: AppLink.kPostAddPath);
    } else {
      return AppLink(location: AppLink.kHomePath);
    }
  }

  @override
  Future<void> setNewRoutePath(AppLink configuration) async {
    switch (configuration.location) {
      case AppLink.kHomePath:
        homeManager.selectedPage(true);
        // postDetailsManager.selectedPage(false);
        // connectUsManager.selectedPage(false);
        break;
      case AppLink.kConnectUsPath:
        connectUsManager.selectedPage(true);

        break;
      case AppLink.kPostPath:
        postDetailsManager.selectedPage(true, post: postDetailsManager.post);
        break;
      case AppLink.kPostAddPath:
        postAddManager.selectedPage(true, post: postAddManager.post,operationType: postAddManager.operationType);
        break;
      default:
        break;
    }
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (route.settings.name == AppPages.homePath) {
      homeManager.selectedPage(false);

    }
    if (route.settings.name == AppPages.connectUsPath) {
      connectUsManager.selectedPage(false);
    }
    if (route.settings.name == AppPages.postPath) {
      postDetailsManager.selectedPage(false);
    }
    if (route.settings.name == AppPages.postAddPath) {
      postAddManager.selectedPage(false,operationType: OperationType.None);
    }
    return true;
  }
}
