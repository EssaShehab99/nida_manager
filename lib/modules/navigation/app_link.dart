class AppLink {
  //screens
  static const String kHomePath = '/home';
  static const String kPostPath = '/post';
  static const String kConnectUsPath = '/connect-us';
  static const String kPostAddPath = '/post-add';

//parameter
  static const String kIdParam = 'id';

  String location;

  String? postId;

  AppLink({required this.location, this.postId});

  static AppLink fromLocation(String? location) {

    location = Uri.decodeFull(location ?? '');
    final uri = Uri.parse(location);
    final params = uri.queryParameters;
    final postId = params[AppLink.kIdParam] ?? '';
    final link = AppLink(
        location: uri.path,
        postId: postId);
    return link;
  }

  String toLocating() {
    String addKeyValPair({required String key, String? value}) =>
        value == null ? '' : '$key=$value&';
    switch (location) {
      case kHomePath:
        return kHomePath;
      case kConnectUsPath:
        return kConnectUsPath;
      case kPostPath:
        var loc = '$kPostPath?';
        loc += addKeyValPair(key: kIdParam, value: postId.toString());
        return Uri.encodeFull(loc);
      case kPostAddPath:
        var loc = '$kPostPath?';
        loc += addKeyValPair(key: kIdParam, value: postId.toString());
        return Uri.encodeFull(loc);
      default:
        return kHomePath;
    }
  }
}
