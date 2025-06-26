import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/reels/presentation/pages/reels_page.dart';
import '../features/stories/presentation/pages/stories_page.dart';
import '../features/marketplace/presentation/pages/marketplace_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';

part 'app_routes.dart';

class AppRouter {
  AppRouter._();

  // Root <Navigator> = gerencia pushes fora do shell (ex.: modais fullscreen)
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  // Shell <Navigator> = troca as páginas dentro do bottom-bar
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: Routes.home.path,
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,      // ← **chave diferente!**
        builder: (_, __, child) => _ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: Routes.home.path,
            name: Routes.home.name,
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: Routes.reels.path,
            name: Routes.reels.name,
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: ReelsPage()),
          ),
          GoRoute(
            path: Routes.stories.path,
            name: Routes.stories.name,
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: StoriesPage()),
          ),
          GoRoute(
            path: Routes.marketplace.path,
            name: Routes.marketplace.name,
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: MarketplacePage()),
          ),
          GoRoute(
            path: Routes.profile.path,
            name: Routes.profile.name,
            pageBuilder: (_, __) =>
            const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),
    ],
  );
}

/// Bottom-bar + área central
class _ScaffoldWithNavBar extends StatefulWidget {
  const _ScaffoldWithNavBar({required this.child});
  final Widget child;

  @override
  State<_ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<_ScaffoldWithNavBar> {
  int _indexFromLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = Routes.values.indexWhere((r) => r.path == location);
    return idx == -1 ? 0 : idx; // fallback seguro
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _indexFromLocation(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.video_collection_outlined), label: 'Reels'),
          NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined), label: 'Stories'),
          NavigationDestination(
              icon: Icon(Icons.storefront_outlined), label: 'Market'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
        onDestinationSelected: (index) =>
            context.go(Routes.values[index].path),
      ),
    );
  }
}
