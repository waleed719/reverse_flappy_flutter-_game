import 'package:flutter/material.dart';

class FloatingCircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback? onPressed;

  const FloatingCircleButton({
    super.key,
    required this.icon,
    required this.color,
    required this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(child: Icon(icon, color: iconColor, size: 22)),
        ),
      ),
    );
  }
}
