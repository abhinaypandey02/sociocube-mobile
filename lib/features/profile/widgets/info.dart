import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sociocube/core/constants/url.dart';
import 'package:sociocube/core/providers/user.dart';
import 'package:sociocube/core/theme/theme.dart';
import 'package:sociocube/core/widgets/avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoCard extends HookConsumerWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final username = user.value?.user?.username ?? '';
    final url = getMeURL(username, true);

    return Row(
      children: [
        Avatar(photoUrl: user.value?.user?.photo, size: 96),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.value?.user?.name ?? '',
              style: TextStyle(fontSize: 24, fontFamily: 'Serif'),
            ),
            GestureDetector(
              onTap: () async {
                final uri = Uri.parse(getMeURL(username, false));
                await launchUrl(uri, mode: LaunchMode.inAppWebView);
              },
              child: Text(url, style: TextStyle(color: AppColors.accent)),
            ),
          ],
        ),
      ],
    );
  }
}
