import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_queries.dart';
import 'graphql_mutations.dart';

class GraphQLService {
  static const String _endpoint = 'https://sociocube.com/api';
  
  static final HttpLink _httpLink = HttpLink(_endpoint);
  
  static final GraphQLClient client = GraphQLClient(
    link: _httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );

  // Reusable GraphQL method for queries
  static Future<QueryResult> query({
    required String document,
    Map<String, dynamic>? variables,
    FetchPolicy? fetchPolicy,
  }) async {
    return await client.query(
      QueryOptions(
        document: gql(document),
        variables: variables ?? {},
        fetchPolicy: fetchPolicy ?? FetchPolicy.noCache,
      ),
    );
  }

  // Reusable GraphQL method for mutations
  static Future<QueryResult> mutate({
    required String document,
    Map<String, dynamic>? variables,
  }) async {
    return await client.mutate(
      MutationOptions(
        document: gql(document),
        variables: variables ?? {},
      ),
    );
  }
} 