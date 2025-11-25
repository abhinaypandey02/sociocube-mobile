import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../utils/env.dart';
import '../../../features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for handling GraphQL operations
/// Provides a configured GraphQL client with authentication
class GraphQLService {
  GraphQLClient? _client;
  final Ref _ref;

  GraphQLService(this._ref) {
    _client = _createClient();
  }

  /// Create a GraphQL client with authentication and error handling
  GraphQLClient _createClient() {
    final httpLink = HttpLink(_getGraphQLEndpoint());

    final authLink = AuthLink(
      getToken: () async {
        // Get fresh token from auth provider on every request
        final token = await _ref
            .read(authStateProvider.notifier)
            .getAccessToken();
        return token != null ? 'Bearer $token' : null;
      },
    );

    final link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.networkOnly,
          error: ErrorPolicy.all,
          cacheReread: CacheRereadPolicy.ignoreAll,
        ),
        mutate: Policies(
          fetch: FetchPolicy.networkOnly,
          error: ErrorPolicy.all,
        ),
      ),
    );
  }

  /// Get the GraphQL endpoint from environment variables
  String _getGraphQLEndpoint() {
    return getEnvVar(EnvKey.backendBaseUrl);
  }

  /// Execute a query
  Future<QueryResult> query(QueryOptions options) async {
    try {
      final result = await _client!.query(options);
      _handleErrors(result);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('GraphQL Query Error: $e');
      }
      rethrow;
    }
  }

  /// Execute a mutation
  Future<QueryResult> mutate(MutationOptions options) async {
    try {
      final result = await _client!.mutate(options);
      _handleErrors(result);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('GraphQL Mutation Error: $e');
      }
      rethrow;
    }
  }

  /// Handle GraphQL errors
  void _handleErrors(QueryResult result) {
    if (result.hasException) {
      final exception = result.exception;

      // Handle network errors
      if (exception?.linkException != null) {
        if (kDebugMode) {
          print('Network Error: ${exception?.linkException}');
        }
        throw Exception(
          'Network error occurred. Please check your connection.',
        );
      }

      // Handle GraphQL errors
      if (exception?.graphqlErrors.isNotEmpty ?? false) {
        final errors = exception!.graphqlErrors;
        if (kDebugMode) {
          print('GraphQL Errors: $errors');
        }

        // Check for authentication errors
        final hasAuthError = errors.any(
          (error) => error.extensions?['code'] == 'UNAUTHENTICATED',
        );

        if (hasAuthError) {
          throw Exception('Authentication failed. Please login again.');
        }

        // Throw first error message
        throw Exception(errors.first.message);
      }
    }
  }
}

final graphqlServiceProvider = Provider<GraphQLService>((ref) {
  return GraphQLService(ref);
});
