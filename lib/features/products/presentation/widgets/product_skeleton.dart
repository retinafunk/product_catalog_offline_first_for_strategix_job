import 'package:flutter/material.dart';

class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
	return const Center(child: CircularProgressIndicator());
  }
}

