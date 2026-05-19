import 'package:go_router/go_router.dart';

import '../presentation/screens/product_detail_screen.dart';
import '../presentation/screens/product_list_screen.dart';

/// Centralised routing configuration using [GoRouter].
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductListScreen(),
      routes: [
        GoRoute(
          path: 'product/:id',
          builder: (context, state) {
            final id = int.tryParse(
                  state.pathParameters['id'] ?? '',
                ) ??
                0;
            return ProductDetailScreen(productId: id);
          },
        ),
      ],
    ),
  ],
);

