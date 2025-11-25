import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sociocube/core/services/graphql/queries/user.graphql.dart';
import 'package:sociocube/core/services/graphql/graphql_service.dart';

class UserProvider extends AsyncNotifier<Query$GetCurrentUser?> {
  @override
  Query$GetCurrentUser? build() {
    return null;
  }

  Future<Query$GetCurrentUser?> fetchUser() async {
    final result = await ref
        .read(graphqlServiceProvider.notifier)
        .query(QueryOptions(document: documentNodeQueryGetCurrentUser));
    if (!result.hasException && result.data != null) {
      final user = Query$GetCurrentUser.fromJson(result.data!);
      state = AsyncData(user);
      return user;
    } else {
      state = AsyncError(result.exception!, StackTrace.current);
    }
    return null;
  }
}

final userProvider = AsyncNotifierProvider<UserProvider, Query$GetCurrentUser?>(
  () => UserProvider(),
);
