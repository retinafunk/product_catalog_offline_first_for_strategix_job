import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
	super.key,
	required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(title: const Text('Product Details')),
	  body: Center(
		child: Text('Product ID: $productId'),
	  ),
	);
  }
}