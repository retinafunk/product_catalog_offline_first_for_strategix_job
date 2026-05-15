import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
	super.key,
	required this.error,
	required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
	return Center(
	  child: Padding(
		padding: const EdgeInsets.all(16),
		child: Column(
		  mainAxisSize: MainAxisSize.min,
		  children: [
			Text('Something went wrong: $error'),
			const SizedBox(height: 12),
			ElevatedButton(
			  onPressed: onRetry,
			  child: const Text('Retry'),
			),
		  ],
		),
	  ),
	);
  }
}

