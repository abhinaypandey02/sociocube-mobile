import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sociocube/core/services/graphql/graphql_service.dart';
import 'package:sociocube/core/services/graphql/queries/user.graphql.dart';

/// Fetches the current account profile details.
final profileProvider = FutureProvider<Query$GetAccountProfileDetails?>((
  ref,
) async {
  final client = ref.read(graphqlServiceProvider.notifier);
  final result = await client.query(
    QueryOptions(document: documentNodeQueryGetAccountProfileDetails),
  );

  if (result.hasException) {
    throw result.exception!;
  }

  final data = result.data;
  if (data == null) return null;

  return Query$GetAccountProfileDetails.fromJson(data);
});
