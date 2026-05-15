import 'package:flutter/material.dart';

import '../../domain-logic/entities/product_entity.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
	super.key,
	required this.product,
	required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
	return InkWell(
	  onTap: onTap,
	  borderRadius: BorderRadius.circular(12),
	  child: Card(
		clipBehavior: Clip.antiAlias,
		child: Column(
		  crossAxisAlignment: CrossAxisAlignment.start,
		  children: [
			Expanded(
			  child: product.thumbnailImage.isEmpty
				  ? const Center(child: Icon(Icons.image_not_supported))
				  : Image.network(
					  product.thumbnailImage,
					  width: double.infinity,
					  fit: BoxFit.cover,
					  errorBuilder: (_, __, ___) =>
						  const Center(child: Icon(Icons.broken_image)),
					),
			),
			Padding(
			  padding: const EdgeInsets.all(8),
			  child: Text(
				product.productName,
				maxLines: 2,
				overflow: TextOverflow.ellipsis,
			  ),
			),
			Padding(
			  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
			  child: Text('\$${product.priceWithTaxes.toStringAsFixed(2)}'),
			),
		  ],
		),
	  ),
	);
  }
}

