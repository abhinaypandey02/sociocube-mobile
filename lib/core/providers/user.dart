import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sociocube/core/services/graphql/queries/user.graphql.dart';
import 'package:sociocube/core/services/graphql/graphql_service.dart';

import '../services/graphql/queries/schema.graphql.dart';

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

  Future<String?> updateUser(
    Map<String, dynamic> user, {
    bool skipMutation = false,
  }) async {
    final current = state.value;
    if (current?.user == null) return null;

    final updatedUserJson = <String, dynamic>{
      ...current!.user!.toJson(),
      ...user,
    };

    if (user['instagramStats'] != null) {
      updatedUserJson['instagramStats'] = <String, dynamic>{
        ...(current.user!.instagramStats?.toJson() ?? {}),
        ...user['instagramStats'],
      };
    }

    state = AsyncData(
      Query$GetCurrentUser.fromJson(<String, dynamic>{
        ...current.toJson(),
        'user': updatedUserJson,
      }),
    );
    if (!skipMutation) {
      try {
        await ref
            .read(graphqlServiceProvider.notifier)
            .mutate(
              MutationOptions(
                document: documentNodeMutationUpdateUser,
                variables: Variables$Mutation$UpdateUser(
                  updatedUser: Input$UpdateUserInput.fromJson(user),
                ).toJson(),
              ),
            );
      } catch (e) {
        return e.toString();
      }
    }
  }
}

final userProvider = AsyncNotifierProvider<UserProvider, Query$GetCurrentUser?>(
  () => UserProvider(),
);
