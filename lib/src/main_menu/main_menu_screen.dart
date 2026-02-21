import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reverse_flappy/src/main_menu/widgets/floating_circle_button.dart';
import 'package:reverse_flappy/src/main_menu/widgets/hills_painter.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';

import '../settings/settings.dart';
import '../style/juicy_button.dart';
import '../style/palette.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

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
                child: CustomPaint(painter: HillsPainter(palette)),
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
                            'v1.0.0',
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
                              GoRouter.of(context).push('/scoreboard');
                            },
                          ),
                          const SizedBox(height: 20),
                          // Small floating buttons row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingCircleButton(
                                icon: Icons.shopping_cart_rounded,
                                color: palette.cardWhite,
                                iconColor: palette.textDark,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 14),
                              FloatingCircleButton(
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
