import 'package:flutter/material.dart';

import '../../domain-logic/entities/product_entity.dart';

class ProductDetailWidget extends StatelessWidget {
  const ProductDetailWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──────────────────────────────────────────────────
          AspectRatio(
            aspectRatio: 16 / 9,
            child: product.thumbnailImage.isEmpty
                ? const Center(
                    child: Icon(Icons.image_not_supported, size: 64))
                : Image.network(
                    product.thumbnailImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image, size: 64)),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Name + brand ─────────────────────────────────────────
                Text(product.productName,
                    style: theme.textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  product.productBrand,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.secondary),
                ),
                const SizedBox(height: 12),
                // ── Prices ───────────────────────────────────────────────
                Row(
                  children: [
                    Text(
                      '\$${product.priceWithTaxes.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'excl. tax: \$${product.priceWithoutTaxes.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Price/kg or litre: \$${product.priceKgOrLitre4Compare.toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall,
                ),
                const Divider(height: 24),
                // ── Category ─────────────────────────────────────────────
                Text('Category: ${product.category}',
                    style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                // ── Description ──────────────────────────────────────────
                Text(product.description,
                    style: theme.textTheme.bodyMedium),
                // ── Tags ─────────────────────────────────────────────────
                if (product.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final tag in product.tags) Chip(label: Text(tag)),
                    ],
                  ),
                ],
                // ── Additional images ─────────────────────────────────────
                if (product.productImages.length > 1) ...[
                  const Divider(height: 24),
                  Text('More images', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.productImages.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, i) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.productImages[i],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
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
    );
  }
}

