import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/palette.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();
    final topScores = playerProgress.topScores;

    return Scaffold(
      backgroundColor: palette.backgroundLightBlue,
      body: SafeArea(
        child: Column(
          children: [
            // Cyan Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: palette.primaryCyan,
                boxShadow: [
                  BoxShadow(
                    color: palette.buttonCyanShadow,
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.white.withAlpha(60),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => GoRouter.of(context).pop(),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'TOP SCORES',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            // Score List
            Expanded(
              child: topScores.isEmpty
                  ? Center(
                      child: Text(
                        'No scores yet. Start playing!',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: palette.textDark.withAlpha(150),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: topScores.length,
                      itemBuilder: (context, index) {
                        final score = topScores[index];
                        final isFirst = index == 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: palette.cardWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: isFirst
                                ? Border.all(
                                    color: palette.primaryYellow,
                                    width: 2,
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Rank Number
                              SizedBox(
                                width: 40,
                                child: Text(
                                  '#${index + 1}',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: isFirst
                                        ? palette.primaryYellow
                                        : palette.textDark.withAlpha(120),
                                  ),
                                ),
                              ),

                              // Score Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'World ${score.level}',
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: palette.textDark.withAlpha(100),
                                      ),
                                    ),
                                    Text(
                                      'Time: ${score.formattedTime}',
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        color: palette.textDark.withAlpha(150),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Big Score Number
                              Text(
                                '${score.score}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: palette.textDark,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
