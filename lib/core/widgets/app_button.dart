import 'package:flutter/material.dart';

/// Reusable primary action button with customizable dimensions and colors.
class AppButton extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Widget? icon;
  final Widget? trailingIcon;

  const AppButton({
    super.key,
    this.width = 0.9,
    this.height = 0.07,
    this.label = 'TEXT',
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.icon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primary;
    final border = borderColor ?? Colors.transparent;
    final txtColor = textColor ?? theme.colorScheme.onPrimary;

    return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      height: (MediaQuery.of(context).size.height * height).clamp(52.0, 70.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: border, width: 1.5),
          ),
          backgroundColor: bg,
          foregroundColor: txtColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: txtColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}

