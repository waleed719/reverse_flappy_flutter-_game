import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A pill-shaped, 3D-shadow button matching the Juicy Arcade design.
class JuicyButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color shadowColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double fontSize;
  final double height;
  final double? width;
  final bool isSmall;

  const JuicyButton({
    required this.label,
    required this.color,
    required this.shadowColor,
    this.icon,
    this.textColor = Colors.white,
    this.onPressed,
    this.fontSize = 20,
    this.height = 56,
    this.width,
    this.isSmall = false,
    super.key,
  });

  @override
  State<JuicyButton> createState() => _JuicyButtonState();
}

class _JuicyButtonState extends State<JuicyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final offset = _pressed ? 2.0 : 5.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.height / 2),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              offset: Offset(0, offset),
              blurRadius: 0,
            ),
          ],
        ),
        transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmall ? 16 : 28,
          vertical: 0,
        ),
        child: Row(
          mainAxisSize: widget.width != null
              ? MainAxisSize.max
              : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.textColor,
                size: widget.fontSize + 4,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              widget.label,
              style: GoogleFonts.beVietnamPro(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w800,
                color: widget.textColor,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small square icon button with 3D shadow (for Home, Restart, etc.)
class JuicyIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final Color shadowColor;
  final Color iconColor;
  final VoidCallback? onPressed;
  final double size;

  const JuicyIconButton({
    required this.icon,
    required this.color,
    required this.shadowColor,
    this.iconColor = Colors.white,
    this.onPressed,
    this.size = 56,
    super.key,
  });

  @override
  State<JuicyIconButton> createState() => _JuicyIconButtonState();
}

class _JuicyIconButtonState extends State<JuicyIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final offset = _pressed ? 2.0 : 4.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              offset: Offset(0, offset),
              blurRadius: 0,
            ),
          ],
        ),
        transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.iconColor,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}
