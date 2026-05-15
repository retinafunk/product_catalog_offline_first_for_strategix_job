/// Typed exceptions used throughout the app so callers can pattern-match on
/// failure cause instead of catching generic [Exception].
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when there is no network and the local cache is empty.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection and no cached data available.',
  ]);
}

/// Thrown when the remote API returns a non-2xx status code.
class ServerException extends AppException {
  const ServerException([super.message = 'A server error occurred.']);
}

/// Thrown when reading or writing to the local Hive store fails.
class CacheException extends AppException {
  const CacheException([super.message = 'A local cache error occurred.']);
}

