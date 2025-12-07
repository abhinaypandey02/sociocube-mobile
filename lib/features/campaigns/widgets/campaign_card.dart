import 'package:flutter/material.dart';
import 'package:sociocube/core/services/graphql/queries/posting.graphql.dart';
import 'package:sociocube/core/widgets/text.dart' as text;

class CampaignCard extends StatelessWidget {
  const CampaignCard({super.key, required this.campaign});

  final Query$GetAllPostings$postings campaign;
  @override
  Widget build(BuildContext context) {
    final description = campaign.description;
    final title = campaign.title.isNotEmpty ? campaign.title : 'Details';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Serif',
              fontVariations: text.getVariations(text.Size.medium, 550),
            ),
          ),
          const SizedBox(height: 8),
          Text(description, maxLines: 4, overflow: TextOverflow.ellipsis),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(title),
                    content: SingleChildScrollView(child: Text(description)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Read more'),
            ),
          ],
        ],
      ),
    );
  }
}
