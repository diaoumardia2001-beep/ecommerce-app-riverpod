import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/product_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/derived_providers.dart';

// ═══════════════════════════════════════════════════════════
//  Entry point — wrapped with ProviderScope
// ═══════════════════════════════════════════════════════════
void main() {
  runApp(const ProviderScope(child: EcommerceApp()));
}

// ═══════════════════════════════════════════════════════════
//  Root widget — Material 3 theme + GoRouter
// ═══════════════════════════════════════════════════════════
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ShopEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006D77), // teal brand colour
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      routerConfig: _router,
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  GoRouter configuration
// ═══════════════════════════════════════════════════════════
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // ShellRoute wraps the 4 tabs with a persistent bottom nav bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => _AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, __) => const NoTransitionPage(
            child: ProductListScreen(),
          ),
        ),
        GoRoute(
          path: '/cart',
          pageBuilder: (_, __) => const NoTransitionPage(
            child: CartScreen(),
          ),
        ),
        GoRoute(
          path: '/favorites',
          pageBuilder: (_, __) => const NoTransitionPage(
            child: FavoritesScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (_, __) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    // Product detail — full‑screen, outside the shell
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/product/:id',
      builder: (_, state) => ProductDetailScreen(
        productId: state.pathParameters['id']!,
      ),
    ),
  ],
);

// ═══════════════════════════════════════════════════════════
//  App shell (Scaffold + BottomNavigationBar + cart badge)
// ═══════════════════════════════════════════════════════════
class _AppShell extends ConsumerWidget {
  final Widget child;
  const _AppShell({required this.child});

  static const _tabs = ['/', '/cart', '/favorites', '/profile'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = _tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabs[i]) && _tabs[i] != '/' || _tabs[i] == '/' && location == '/') {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartItemCountProvider);
    final currentIdx = _currentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ShopEase',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Panier',
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              onPressed: () => context.go('/cart'),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Catalogue',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Panier',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
