import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/connectivity_provider.dart';
import '../providers/product_providers.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/offline_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/product_skeleton.dart';

/// The first screen: a scrollable grid of products with pull-to-refresh,
/// offline indication, and loading / error / empty states.
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productListProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        centerTitle: true,
        actions: [
          // Show a subtle loading indicator in the AppBar during a refresh so
          // the user knows something is happening.
          if (productState.isLoading && productState.valueOrNull != null)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ── Offline banner ───────────────────────────────────────────────
          if (!isOnline) const OfflineBanner(),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: productState.when(
              // Keep showing data during a background refresh
              skipLoadingOnRefresh: true,

              loading: () => const ProductListSkeleton(),

              error: (error, _) => ErrorView(
                error: error,
                onRetry: () => ref.invalidate(productListProvider),
              ),

              data: (result) {
                if (result.products.isEmpty) {
                  return EmptyView(
                    onRefresh: () =>
                        ref.read(productListProvider.notifier).refresh(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(productListProvider.notifier).refresh(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: result.products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = result.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () =>
                            context.push('/product/${product.id}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

