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
        Provider(create: (context) => CatalogModel()),
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
