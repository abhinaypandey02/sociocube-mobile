import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/graphql.dart';
import 'auth.dart';

// GraphQL client provider that rebuilds when access token changes
final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  // Watch access token to rebuild client when it changes
  ref.watch(accessTokenProvider);
  
  return GraphQLService.createClient(ref);
}); 