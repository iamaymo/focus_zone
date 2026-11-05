import 'package:flutter/material.dart';

import '../../../../core/extensions/task_priority_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/task_item.dart';

/// Horizontal filter bar for filtering tasks by priority with a search trigger icon.
class TaskFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final VoidCallback onSearchPressed;

  const TaskFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: colors.primary,
          ),
          tooltip: loc.search,
          onPressed: onSearchPressed,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  id: 'all',
                  label: loc.all,
                  icon: Icons.filter_list_rounded,
                  color: colors.primary,
                  isSelected: selectedFilter == 'all',
                  onTap: () => onFilterSelected('all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  id: 'high',
                  label: TaskPriority.high.label(context),
                  icon: Icons.flag_rounded,
                  color: TaskPriority.high.color,
                  isSelected: selectedFilter == 'high',
                  onTap: () => onFilterSelected('high'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  id: 'medium',
                  label: TaskPriority.medium.label(context),
                  icon: Icons.flag_rounded,
                  color: TaskPriority.medium.color,
                  isSelected: selectedFilter == 'medium',
                  onTap: () => onFilterSelected('medium'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  id: 'low',
                  label: TaskPriority.low.label(context),
                  icon: Icons.flag_outlined,
                  color: TaskPriority.low.color,
                  isSelected: selectedFilter == 'low',
                  onTap: () => onFilterSelected('low'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.25),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : colors.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

