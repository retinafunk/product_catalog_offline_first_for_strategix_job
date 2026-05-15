import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper around [Connectivity] to decouple the rest of the app from the
/// third-party package and to make it easy to mock in tests.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Emits a new [List<ConnectivityResult>] whenever connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// Returns `true` when at least one of the current connectivity results is
  /// not [ConnectivityResult.none].
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }
}

