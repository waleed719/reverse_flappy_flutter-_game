import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../player_progress/score.dart';
import '../player_progress/player_progress.dart';
import '../style/juicy_button.dart';
import '../style/palette.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;

  const WinGameScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final palette = context.watch<Palette>();

    final topScores = context.watch<PlayerProgress>().topScores;
    final bestScore = topScores.isNotEmpty
        ? topScores.first.score
        : score.score;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E).withAlpha(230),
              const Color(0xFF16213E).withAlpha(240),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left side: Title + ad banner
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "CRASHED!" title
                      Text(
                        'CRASHED!',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          letterSpacing: 3,
                          shadows: [
                            const Shadow(
                              blurRadius: 0,
                              color: Colors.black54,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Cyan motivational text
                      Text(
                        'Tap Retry to beat your high score!',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: palette.primaryCyan,
                        ),
                      ),
                      if (adsControllerAvailable) ...[
                        const SizedBox(height: 16),
                        const SizedBox(
                          height: 60,
                          child: Center(child: BannerAdWidget()),
                        ),
                      ],
                    ],
                  ),
                ),

                // Right side: Score card + buttons
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Score card
                      Container(
                        width: 260,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Score
                            Text(
                              'SCORE',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: palette.textDark.withAlpha(140),
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${score.score}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: palette.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(
                              color: palette.textDark.withAlpha(20),
                              height: 1,
                            ),
                            const SizedBox(height: 12),
                            // Best score
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'BEST',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: palette.textDark.withAlpha(140),
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$bestScore',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: palette.primaryYellow,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Time: ${score.formattedTime}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: palette.textDark.withAlpha(120),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Home button
                          JuicyIconButton(
                            icon: Icons.home_rounded,
                            color: Colors.white,
                            shadowColor: Colors.grey.shade400,
                            iconColor: palette.textDark,
                            onPressed: () => GoRouter.of(context).go('/'),
                          ),
                          const SizedBox(width: 18),
                          // Retry button
                          JuicyButton(
                            label: 'RETRY',
                            icon: Icons.refresh_rounded,
                            color: palette.buttonGreen,
                            shadowColor: palette.buttonGreenShadow,
                            fontSize: 18,
                            height: 56,
                            onPressed: () => GoRouter.of(
                              context,
                            ).go('/play/session/${score.level}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
