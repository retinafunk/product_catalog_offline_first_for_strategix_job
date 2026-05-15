import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
	return Container(
	  width: double.infinity,
	  color: Colors.orange.shade100,
	  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
	  child: const Text(
		'Offline mode',
		textAlign: TextAlign.center,
	  ),
	);
  }
}

