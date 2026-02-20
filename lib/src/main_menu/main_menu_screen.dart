import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/juicy_button.dart';
import '../style/palette.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.backgroundLightBlue, palette.backgroundBeige],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Green hills at the bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 100,
                child: CustomPaint(painter: _HillsPainter(palette)),
              ),

              // Settings gear — top right
              Positioned(
                top: 12,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: palette.textDark.withAlpha(180),
                    size: 28,
                  ),
                  onPressed: () => GoRouter.of(context).push('/settings'),
                ),
              ),

              // Mute button — top left
              Positioned(
                top: 12,
                left: 16,
                child: ValueListenableBuilder<bool>(
                  valueListenable: settingsController.muted,
                  builder: (context, muted, child) {
                    return IconButton(
                      onPressed: () => settingsController.toggleMuted(),
                      icon: Icon(
                        muted ? Icons.volume_off : Icons.volume_up,
                        color: palette.textDark.withAlpha(180),
                        size: 28,
                      ),
                    );
                  },
                ),
              ),

              // Main content — landscape-adapted layout
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left: Title
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'REVERSE\n',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    color: palette.primaryCyan,
                                    height: 1.1,
                                    letterSpacing: 3,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 0,
                                        color: palette.buttonCyanShadow,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                ),
                                TextSpan(
                                  text: 'FLAPPY',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    color: palette.primaryYellow,
                                    height: 1.1,
                                    letterSpacing: 3,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 0,
                                        color: palette.buttonYellowShadow,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'v1.0.4 — beta',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: palette.textDark.withAlpha(120),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right: Buttons
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          JuicyButton(
                            label: 'START CRUSHING',
                            icon: Icons.play_arrow_rounded,
                            color: palette.buttonYellow,
                            shadowColor: palette.buttonYellowShadow,
                            textColor: Colors.white,
                            fontSize: 18,
                            height: 58,
                            onPressed: () {
                              audioController.playSfx(SfxType.buttonTap);
                              GoRouter.of(context).go('/play');
                            },
                          ),
                          const SizedBox(height: 18),
                          JuicyButton(
                            label: 'TOP SCORES',
                            icon: Icons.emoji_events_rounded,
                            color: palette.buttonCyan,
                            shadowColor: palette.buttonCyanShadow,
                            textColor: Colors.white,
                            fontSize: 18,
                            height: 58,
                            onPressed: () {
                              GoRouter.of(context).push('./scoreboard');
                              // if (gamesServicesController != null) {
                              //   gamesServicesController.showLeaderboard();
                              // }
                            },
                          ),
                          const SizedBox(height: 20),
                          // Small floating buttons row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _FloatingCircleButton(
                                icon: Icons.shopping_cart_rounded,
                                color: palette.cardWhite,
                                iconColor: palette.textDark,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 14),
                              _FloatingCircleButton(
                                icon: Icons.share_rounded,
                                color: palette.cardWhite,
                                iconColor: palette.textDark,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small circular floating button (Store, Share)
class _FloatingCircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback? onPressed;

  const _FloatingCircleButton({
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

/// Custom painter for green hill silhouettes at the bottom of main menu.
class _HillsPainter extends CustomPainter {
  final Palette palette;

  _HillsPainter(this.palette);

  @override
  void paint(Canvas canvas, Size size) {
    // Back hill
    final backPaint = Paint()..color = palette.hillGreen.withAlpha(180);
    final backPath = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.1,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.9,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(backPath, backPaint);

    // Front hill
    final frontPaint = Paint()..color = palette.groundGreen;
    final frontPath = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.3,
        size.width * 0.6,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 1.0,
        size.width,
        size.height * 0.6,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
