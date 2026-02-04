import 'package:flutter/material.dart';
import '../../foundation/v_colors.dart';
import '../../foundation/v_radius.dart';

/// Base card container with border and padding.
class VCard extends StatelessWidget {
  /// Child widget inside the card.
  final Widget child;

  /// Inner padding for the card.
  final EdgeInsetsGeometry padding;

  /// Creates a [VCard].
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

/// Card that displays a media image with text.
class VMediaCard extends StatelessWidget {
  /// Title text.
  final String title;

  /// Subtitle text.
  final String subtitle;

  /// Image provider for the media.
  final ImageProvider image;

  /// Creates a [VMediaCard].
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

/// Card with description and action widgets.
class VActionCard extends StatelessWidget {
  /// Title text.
  final String title;

  /// Description text.
  final String description;

  /// Action widgets shown at the bottom.
  final List<Widget> actions;

  /// Creates a [VActionCard].
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

/// Card displaying an avatar with name and subtitle.
class VProfileCard extends StatelessWidget {
  /// Profile name.
  final String name;

  /// Subtitle text.
  final String subtitle;

  /// Avatar image provider.
  final ImageProvider avatar;

  /// Creates a [VProfileCard].
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

/// Card showing a stat value with an optional change.
class VStatsCard extends StatelessWidget {
  /// Label for the stat.
  final String label;

  /// Value for the stat.
  final String value;

  /// Optional change indicator text.
  final String? change;

  /// Creates a [VStatsCard].
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

/// Card tile with an icon and two lines of text.
class VDashboardTile extends StatelessWidget {
  /// Title text.
  final String title;

  /// Subtitle text.
  final String subtitle;

  /// Icon displayed on the left.
  final IconData icon;

  /// Creates a [VDashboardTile].
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
