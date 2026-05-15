import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../products/presentation/screens/product_list_screen.dart';

/// Centralised routing configuration using [GoRouter].
final appNavRouter = GoRouter(
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
            return Scaffold(
              appBar: AppBar(title: const Text('Product Details')),
              body: Center(child: Text('Product ID: $id')),
            );
          },
        ),
      ],
    ),
  ],
);



