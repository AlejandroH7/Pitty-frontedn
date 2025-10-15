import 'package:flutter/material.dart';

class SectionMenuCard extends StatelessWidget {
  const SectionMenuCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.primary,
          width: 1.2,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: colorScheme.outlineVariant,
          splashFactory: InkRipple.splashFactory,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.primary,
          collapsedTextColor: colorScheme.primary,
          textColor: colorScheme.primary,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          children: children,
        ),
      ),
    );
  }
}
