import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.onPullToRefresh});

  final Future<void> Function() onPullToRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPullToRefresh,
        child: const Text('Pull to Refresh products list!'),
      ),
    );
  }
}
