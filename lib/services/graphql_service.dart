import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';

import 'graphql_queries.dart';
import 'graphql_mutations.dart';

class GraphQLService {
  static const String _endpoint = 'https://sociocube.com/api';

  // Create a custom HttpClient that disables certificate verification (only in dev)
  static HttpLink get _httpLink {
    if (kDebugMode || kProfileMode) {
      final HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return HttpLink(_endpoint, httpClient: IOClient(client));
    } else {
      return HttpLink(_endpoint);
    }
  }

  static final GraphQLClient client = GraphQLClient(
    link: _httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );

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
