import 'package:flutter/material.dart';

/// Floating decorative task and pomodoro icons for the gateway background.
class FloatingTaskBadges extends StatelessWidget {
  final ColorScheme colorScheme;

  const FloatingTaskBadges({
    super.key,
    required this.colorScheme,
  });

  static const List<_IconBadgeData> _badges = [
    _IconBadgeData(
      top: 40,
      left: 24,
      icon: Icons.checklist_rounded,
      size: 34,
      opacity: 0.16,
      angle: -0.2,
    ),
    _IconBadgeData(
      top: 75,
      right: 32,
      icon: Icons.timer_outlined,
      size: 38,
      opacity: 0.20,
      angle: 0.25,
    ),
    _IconBadgeData(
      top: 155,
      left: 36,
      icon: Icons.check_circle_outline_rounded,
      size: 30,
      opacity: 0.15,
      angle: 0.15,
    ),
    _IconBadgeData(
      top: 180,
      right: 30,
      icon: Icons.hourglass_top_rounded,
      size: 32,
      opacity: 0.18,
      angle: -0.18,
    ),
    _IconBadgeData(
      top: 260,
      left: 45,
      icon: Icons.track_changes_rounded,
      size: 28,
      opacity: 0.14,
      angle: 0.1,
    ),
    _IconBadgeData(
      top: 275,
      right: 50,
      icon: Icons.alarm_on_rounded,
      size: 30,
      opacity: 0.16,
      angle: -0.15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final iconColor = colorScheme.onPrimary;

    return IgnorePointer(
      child: Stack(
        children: _badges.map((badge) {
          return Positioned(
            top: badge.top,
            left: badge.left,
            right: badge.right,
            child: Transform.rotate(
              angle: badge.angle,
              child: Icon(
                badge.icon,
                size: badge.size,
                color: iconColor.withValues(alpha: badge.opacity),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _IconBadgeData {
  final double? top;
  final double? left;
  final double? right;
  final IconData icon;
  final double size;
  final double opacity;
  final double angle;

  const _IconBadgeData({
    this.top,
    this.left,
    this.right,
    required this.icon,
    required this.size,
    required this.opacity,
    required this.angle,
  });
}

