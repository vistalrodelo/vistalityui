import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

class VCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const VCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final vc = theme.extension<VColors>() ?? VColors.fromScheme(cs);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: vc.outline),
        borderRadius: context.vRadius.defaultBorderRadius(),
      ),
      child: child,
    );
  }
}

class VMediaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider image;

  const VMediaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: context.vRadius.defaultBorderRadius(),
            child: Image(image: image, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class VActionCard extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> actions;

  const VActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: actions),
        ],
      ),
    );
  }
}

class VProfileCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final ImageProvider avatar;

  const VProfileCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Row(
        children: [
          CircleAvatar(backgroundImage: avatar, radius: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class VStatsCard extends StatelessWidget {
  final String label;
  final String value;
  final String? change;

  const VStatsCard({
    super.key,
    required this.label,
    required this.value,
    this.change,
  });

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          if (change != null) ...[
            const SizedBox(height: 4),
            Text(change!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class VDashboardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const VDashboardTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return VCard(
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
