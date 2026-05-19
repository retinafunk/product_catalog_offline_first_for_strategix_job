import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/product_providers.dart';
import '../widgets/error_view.dart';
import '../widgets/offline_cached_image.dart';

/// Displays the full details of a product and allows toggling the favorite
/// state. Pulls data from the already-loaded product list so no extra request
/// is made — works fully offline.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(productListProvider);

    return Scaffold(
      body: listState.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(error: error),
        ),
        data: (result) {
          final product = result.products.cast<Product?>().firstWhere(
                (p) => p?.id == productId,
                orElse: () => null,
              );

          if (product == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Product not found.')),
            );
          }

          return _ProductDetailView(product: product);
        },
      ),
    );
  }
}

class _ProductDetailView extends ConsumerWidget {
  const _ProductDetailView({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isFavorite = ref.watch(favoritesProvider
        .select((favorites) => favorites.contains(product.id)));

    return Scaffold(
      // ── App bar ───────────────────────────────────────────────────────────
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(isFavorite),
                color: isFavorite ? Colors.red : null,
              ),
            ),
            onPressed: () =>
                ref.read(favoritesProvider.notifier).toggle(product.id),
          ),
        ],
      ),

      // ── Body ──────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image ─────────────────────────────────────────────────
            Hero(
              tag: 'product-image-${product.id}',
              child: OfflineCachedImage(
                imageUrl: product.thumbnail,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholderBuilder: (_) => Container(
                  height: 280,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorBuilder: (_) => Container(
                  height: 280,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image,
                      size: 64, color: Colors.grey),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title + price row ─────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ── Category chip ─────────────────────────────────────────
                  Chip(
                    label: Text(product.category),
                    visualDensity: VisualDensity.compact,
                    backgroundColor:
                        theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer),
                  ),

                  // ── Tags ──────────────────────────────────────────────────
                  if (product.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: product.tags
                          .map(
                            (tag) => Chip(
                              label: Text('#$tag'),
                              visualDensity: VisualDensity.compact,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ── Description ───────────────────────────────────────────
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(height: 1.5),
                  ),

                  // ── Additional images ─────────────────────────────────────
                  if (product.images.length > 1) ...[
                    const SizedBox(height: 20),
                    Text(
                      'More Images',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            product.images.length > 4 ? 4 : product.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: OfflineCachedImage(
                            imageUrl: product.images[i],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_) => Container(
                              width: 100,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
