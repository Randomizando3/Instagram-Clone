part of 'app_router.dart';

enum Routes {
  home('/'),
  reels('/reels'),
  stories('/stories'),
  marketplace('/market'),
  profile('/profile');

  const Routes(this.path);
  final String path;
}
