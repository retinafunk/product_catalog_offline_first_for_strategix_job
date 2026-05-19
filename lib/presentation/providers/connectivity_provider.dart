import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'infrastructure_providers.dart';

/// Streams real-time connectivity changes as a list of [ConnectivityResult].
final connectivityStreamProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
});

/// Synchronous helper derived from [connectivityStreamProvider].
/// Returns `true` when any connectivity result is not [ConnectivityResult.none].
/// Defaults to `true` while the stream hasn't emitted yet (avoids a false
/// offline flash on startup).
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityStreamProvider);
  return connectivity.when(
    data: (results) =>
        results.isNotEmpty && !results.contains(ConnectivityResult.none),
    loading: () => true,
    error: (_, __) => true,
  );
});

