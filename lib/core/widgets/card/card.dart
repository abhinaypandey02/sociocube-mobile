import 'package:flutter/material.dart';
import 'package:sociocube/core/widgets/text.dart';

/// Represents a single action button for the card's header
class CardAction {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final double? iconSize;

  const CardAction({
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.iconSize = 24.0,
  });
}

/// A reusable card wrapper component with optional header and right-aligned actions
class AppCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<CardAction>? rightActions;
  final Widget? child;

  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.rightActions,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = BorderRadius.circular(16.0);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: defaultBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title, subtitle, and actions
          if (title != null || subtitle != null || rightActions != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and subtitle column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Serif',
                              fontVariations: getVariations(Size.medium, 550),
                            ),
                          ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Right actions
                  if (rightActions != null && rightActions!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: rightActions!.map((action) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: Icon(
                              action.icon,
                              color:
                                  action.iconColor ?? theme.colorScheme.primary,
                              size: action.iconSize,
                            ),
                            onPressed: action.onPressed,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashRadius: 20,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          // Child content
          if (child != null)
            Padding(
              padding: title != null || subtitle != null
                  ? const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0)
                  : const EdgeInsets.all(20.0),
              child: child,
            ),
        ],
      ),
    );
  }
}
