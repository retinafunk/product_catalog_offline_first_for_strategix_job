import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper around [Connectivity] used by the repository to decide
/// whether to attempt a remote fetch or serve from cache.
class ConnectivityService {
  ConnectivityService([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Returns `true` when at least one active network interface is available.
  Future<bool> get isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result.any((status) => status != ConnectivityResult.none);
  }
}

