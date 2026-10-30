import 'package:flutter/material.dart';
import '../../foundation/v_radius.dart';

/// Base card container with border and padding.
class VCard extends StatelessWidget {
  /// Child widget inside the card.
  final Widget child;

  /// Inner padding for the card.
  final EdgeInsetsGeometry padding;

  /// Outer margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Fill color. Defaults to the theme surface color.
  final Color? color;

  /// Called when the card is tapped. The splash follows the card radius.
  final VoidCallback? onTap;

  /// Radius token or identifier resolved by [VRadius].
  final Object? radius;

  /// Explicit radius override when not using a token.
  final double? radiusValue;

  /// Full corner radius. Wins over [radius] and [radiusValue].
  final BorderRadius? borderRadius;

  /// Drop shadow drawn behind the card.
  final List<BoxShadow>? shadow;

  /// Creates a [VCard].
  const VCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.color,
    this.onTap,
    this.radius,
    this.radiusValue,
    this.borderRadius,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final resolvedRadius = borderRadius ??
        context.vRadius.resolveBorderRadius(
          radius: radius,
          radiusValue: radiusValue,
        );
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: resolvedRadius,
        boxShadow: shadow,
      ),
      child: Material(
        color: color ?? cs.surface,
        borderRadius: resolvedRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: resolvedRadius,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: resolvedRadius,
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
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
