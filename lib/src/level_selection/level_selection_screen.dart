import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF87CEEB), palette.backgroundLightBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar: Back + Title + Coin counter
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Back arrow
                    _CircleBackButton(
                      onPressed: () => GoRouter.of(context).go('/'),
                    ),
                    const Spacer(),
                    // Title
                    Text(
                      'SELECT WORLD',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: palette.textDark,
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    // Coin counter pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: palette.primaryYellow,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: palette.buttonYellowShadow,
                            offset: const Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.monetization_on_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '1,250',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // World cards — horizontal scrolling for landscape
              Expanded(
                child: Center(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: 12,
                    ),
                    itemCount: gameLevels.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 24),
                    itemBuilder: (context, index) {
                      final level = gameLevels[index];
                      final isUnlocked =
                          playerProgress.highestLevelReached >=
                          level.number - 1;

                      return _WorldCard(
                        level: level,
                        isUnlocked: isUnlocked,
                        palette: palette,
                        onPlay: () {
                          if (!isUnlocked) return;
                          final audioController = context
                              .read<AudioController>();
                          audioController.playSfx(SfxType.buttonTap);
                          GoRouter.of(
                            context,
                          ).go('/play/session/${level.number}');
                        },
                      );
                    },
                  ),
                ),
              ),

              // Bottom dots indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    gameLevels.length,
                    (i) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == 0
                            ? palette.primaryYellow
                            : palette.textDark.withAlpha(60),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A world card with preview, name, star rating, and play button.
class _WorldCard extends StatelessWidget {
  final GameLevel level;
  final bool isUnlocked;
  final Palette palette;
  final VoidCallback onPlay;

  const _WorldCard({
    required this.level,
    required this.isUnlocked,
    required this.palette,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.height * 0.55;

    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.55,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: palette.cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // World preview image area
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(level.worldColor).withAlpha(40),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Center(
                  child: Text(
                    level.worldIcon,
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),

            // Info section
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // World number label
                    Text(
                      'WORLD ${level.number}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(level.worldColor),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // World name
                    Text(
                      level.worldName,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: palette.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Star rating
                    Row(
                      children: List.generate(3, (i) {
                        return Icon(
                          i == 0
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: palette.primaryYellow,
                          size: 24,
                        );
                      }),
                    ),
                    const Spacer(),
                    // Play button
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: onPlay,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? palette.primaryYellow
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isUnlocked
                                    ? palette.buttonYellowShadow
                                    : Colors.grey.shade500,
                                offset: const Offset(0, 3),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isUnlocked
                                    ? Icons.play_arrow_rounded
                                    : Icons.lock_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isUnlocked ? 'PLAY' : 'LOCKED',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CircleBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Center(child: Icon(Icons.arrow_back_rounded, size: 22)),
        ),
      ),
    );
  }
}
