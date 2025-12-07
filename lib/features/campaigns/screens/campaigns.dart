import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/campaigns_provider.dart';
import '../widgets/campaign_card.dart';

class CampaignsScreen extends HookConsumerWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaigns = ref.watch(campaignsNotifierProvider);
    final pageController = usePageController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns'),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: campaigns.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Failed to load campaigns: $err')),
        data: (data) {
          final postings = data.postings;
          final notifier = ref.read(campaignsNotifierProvider.notifier);

          // Prefetch next page when nearing the end (second last)
          useEffect(() {
            void listener() {
              final page = pageController.page ?? 0;
              if (postings.isNotEmpty && page > postings.length - 2) {
                notifier.loadNextPage();
              }
            }

            pageController.addListener(listener);
            return () => pageController.removeListener(listener);
          }, [postings.length, pageController]);

          if (postings.isEmpty) {
            return const Center(child: Text('No campaigns found'));
          }
          return PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemCount: postings.length,
            itemBuilder: (context, index) {
              return CampaignCard(campaign: postings[index]);
            },
          );
        },
      ),
    );
  }
}
