import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../settings/settings.dart';
import '../style/juicy_button.dart';
import '../style/palette.dart';
import '../game_internals/my_game.dart';

/// "CHILL TIME" pause overlay matching Stitch design.
class PauseOverlay extends StatelessWidget {
  final MyGame game;
  final VoidCallback onResume;

  const PauseOverlay({required this.game, required this.onResume, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settings = context.watch<SettingsController>();

    return Container(
      color: palette.darkOverlay,
      child: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: palette.cardWhite,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // "CHILL TIME" title
              Text(
                'CHILL TIME',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: palette.primaryCyan,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 24),

              // Music toggle
              ValueListenableBuilder<bool>(
                valueListenable: settings.musicOn,
                builder: (context, musicOn, _) => _PauseToggleRow(
                  label: 'MUSIC',
                  icon: Icons.music_note_rounded,
                  value: musicOn,
                  activeColor: palette.primaryGreen,
                  onChanged: (_) => settings.toggleMusicOn(),
                ),
              ),
              const SizedBox(height: 10),

              // SFX toggle
              ValueListenableBuilder<bool>(
                valueListenable: settings.soundsOn,
                builder: (context, soundsOn, _) => _PauseToggleRow(
                  label: 'SFX',
                  icon: Icons.graphic_eq_rounded,
                  value: soundsOn,
                  activeColor: palette.primaryGreen,
                  onChanged: (_) => settings.toggleSoundsOn(),
                ),
              ),

              const SizedBox(height: 28),

              // Buttons row: Home, Restart, Resume
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Home button (red)
                  JuicyIconButton(
                    icon: Icons.home_rounded,
                    color: palette.buttonRed,
                    shadowColor: palette.buttonRedShadow,
                    iconColor: Colors.white,
                    size: 52,
                    onPressed: () => GoRouter.of(context).go('/'),
                  ),
                  const SizedBox(width: 14),

                  // Restart button (orange)
                  JuicyIconButton(
                    icon: Icons.refresh_rounded,
                    color: palette.buttonOrange,
                    shadowColor: const Color(0xFFE68900),
                    iconColor: Colors.white,
                    size: 52,
                    onPressed: () => GoRouter.of(context).go('/play'),
                  ),
                  const SizedBox(width: 14),

                  // Resume button (green, wide)
                  JuicyButton(
                    label: 'RESUME',
                    icon: Icons.play_arrow_rounded,
                    color: palette.buttonGreen,
                    shadowColor: palette.buttonGreenShadow,
                    fontSize: 18,
                    height: 52,
                    onPressed: onResume,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PauseToggleRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _PauseToggleRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: activeColor, size: 22),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
              letterSpacing: 1,
            ),
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: activeColor),
      ],
    );
  }
}
