import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sociocube/core/services/graphql/graphql_service.dart';
import 'package:sociocube/core/services/graphql/queries/posting.graphql.dart';

class CampaignsState {
  final List<Query$GetAllPostings$postings> postings;
  final double page;
  final bool hasMore;
  final bool isLoadingMore;

  CampaignsState({
    required this.postings,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
  });

  CampaignsState copyWith({
    List<Query$GetAllPostings$postings>? postings,
    double? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CampaignsState(
      postings: postings ?? this.postings,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CampaignsNotifier extends AsyncNotifier<CampaignsState> {
  @override
  Future<CampaignsState> build() async {
    return await _fetchPage(1, replace: true);
  }

  Future<CampaignsState> _fetchPage(
    double page, {
    required bool replace,
  }) async {
    final client = ref.read(graphqlServiceProvider.notifier);
    final result = await client.query(
      QueryOptions(
        document: documentNodeQueryGetAllPostings,
        variables: Variables$Query$GetAllPostings(page: page).toJson(),
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data;
    if (data == null) {
      return state.value ??
          CampaignsState(
            postings: [],
            page: 1,
            hasMore: false,
            isLoadingMore: false,
          );
    }
    final parsed = Query$GetAllPostings.fromJson(data);
    final newPostings = parsed.postings;
    final merged = <Query$GetAllPostings$postings>[
      ...(state.value?.postings ?? []),
      ...newPostings,
    ];

    // If fetched less than requested page size, assume no more pages
    final hasMore = newPostings.isNotEmpty;

    final nextState = CampaignsState(
      postings: merged,
      page: page,
      hasMore: hasMore,
      isLoadingMore: false,
    );
    state = AsyncData(nextState);
    return nextState;
  }

  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null) return;
    if (current.isLoadingMore) return;
    if (!current.hasMore) return;
    final nextPage = current.page + 1;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      await _fetchPage(nextPage, replace: false);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final campaignsNotifierProvider =
    AsyncNotifierProvider<CampaignsNotifier, CampaignsState>(
      CampaignsNotifier.new,
    );
