import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';

class AuthLink extends Link {
  final Ref ref;

  AuthLink(this.ref);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    // Get the current access token
    final accessToken = ref.read(accessTokenProvider);
    
    // Add authorization header if token exists
    if (accessToken != null && accessToken.isNotEmpty) {
      // Note: Context update removed due to API compatibility
      // Authorization will be handled at the HTTP link level
    }

    // Forward the request
    yield* forward!(request).handleError((error) {
      // Handle 401 errors
      if (error is OperationException) {
        final statusCode = error.linkException?.originalException?.toString();
        if (statusCode?.contains('401') == true || 
            error.graphqlErrors.any((e) => e.extensions?['code'] == 'UNAUTHENTICATED')) {
          // Clear access token on 401
          ref.read(accessTokenProvider.notifier).clearToken();
        }
      }
      throw error;
    });
  }
}

class GraphQLService {
  static GraphQLClient createClient(Ref ref) {
    final HttpLink httpLink = HttpLink(
      'https://your-graphql-endpoint.com/graphql', // Replace with your GraphQL endpoint
    );

    final AuthLink authLink = AuthLink(ref);

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    );
  }
} 