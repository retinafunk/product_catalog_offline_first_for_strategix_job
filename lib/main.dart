import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common/constants/app_constants.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive and open the boxes required by the app.
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AppConstants.productsBoxName);
  await Hive.openBox<dynamic>(AppConstants.favoritesBoxName);
  await Hive.openBox<dynamic>(AppConstants.imagesBoxName);

  runApp(
    // ProviderScope is the root of the Riverpod dependency graph.
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      routerConfig: appRouter,
    );
  }
}
