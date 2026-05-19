import 'package:flutter/material.dart';

import '../../common/errors/app_exception.dart';

/// Generic error state widget with a retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, message) = switch (error) {
      NetworkException e => (Icons.wifi_off_rounded, e.message),
      ServerException e => (Icons.cloud_off_rounded, e.message),
      CacheException e => (Icons.storage_rounded, e.message),
      _ => (
          Icons.error_outline_rounded,
          'Something went wrong. Please try again.',
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

