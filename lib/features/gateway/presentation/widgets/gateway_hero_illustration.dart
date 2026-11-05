import 'package:flutter/material.dart';

/// Central Pomodoro and To-Do visual illustration on the Gateway screen.
class GatewayHeroIllustration extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isArabic;

  const GatewayHeroIllustration({
    super.key,
    required this.colorScheme,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer glowing ring
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.onPrimary.withValues(alpha: 0.08),
                border: Border.all(
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),

            // Middle ring
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.onPrimary.withValues(alpha: 0.14),
              ),
            ),

            // Center Pomodoro Timer icon and text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_rounded,
                  size: 46,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(height: 2),
                Text(
                  '25:00',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            // Floating Top Chip: "Tasks Done"
            Positioned(
              top: -8,
              right: isArabic ? null : -24,
              left: isArabic ? -24 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xff81c784),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? 'إنجاز المهام' : 'Tasks Done',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Bottom Chip: "Focus Mode"
            Positioned(
              bottom: -8,
              left: isArabic ? null : -20,
              right: isArabic ? -20 : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xffffb74d),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? 'تركيز بومودورو' : 'Focus Mode',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Brand Title Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: colorScheme.onPrimary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Focus zone',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

