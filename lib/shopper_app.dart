import 'package:flutter/material.dart';
import 'package:flutter_provider_example_app/common/theme.dart';
import 'package:flutter_provider_example_app/models/cart.dart';
import 'package:flutter_provider_example_app/models/catalog.dart';
import 'package:flutter_provider_example_app/screens/cart.dart';
import 'package:flutter_provider_example_app/screens/catalog.dart';
import 'package:flutter_provider_example_app/screens/login.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void executeShopperApp() {
  runApp(const ShopperApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const MyLogin(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const MyCatalog(),
        routes: [
          GoRoute(
            path: 'cart',
            builder: (context, state) => const MyCart(),
          ),
        ],
      ),
    ],
  );
}

class ShopperApp extends StatelessWidget {
  const ShopperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// CatalogModel 는 절대 변경 되지 않으 므로 간단한 Provider 로 구현 되어 있다.
        Provider(create: (context) => CatalogModel()),
        /// 다른 ChangeNotifier 에 종속적인 Provider 인 경우 ChangeNotifierProxyProvider 사용!!
        /// CartModel 이 CatalogModel 포함 하고 있음.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Provider Demo',
        theme: appTheme,
        routerConfig: router(),
      ),
    );
  }
}
