import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/my_game.dart';
import '../game_internals/level_state.dart';
import '../player_progress/score.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/palette.dart';
import 'pause_overlay.dart';

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);
  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;
  bool _isPaused = false;

  late DateTime _startOfPlay;
  late final MyGame _myGame;

  /// Timer to periodically refresh the score display
  Timer? _scoreTimer;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              LevelState(goal: widget.level.difficulty, onWin: _playerWon),
        ),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          body: Stack(
            children: [
              // The Flame game fills the entire screen
              GameWidget(game: _myGame),

              // Score display — top center (Stitch HUD style)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Big score number with outline
                        Text(
                          '${_myGame.score}',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                blurRadius: 0,
                                color: Colors.black54,
                                offset: Offset(2, 2),
                              ),
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black.withAlpha(60),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        // Elapsed timer (smaller)
                        Text(
                          _formatTime(_myGame.elapsedTime),
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withAlpha(180),
                            shadows: [
                              const Shadow(
                                blurRadius: 2,
                                color: Colors.black38,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Pause button — top right (circular)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Material(
                      color: Colors.white.withAlpha(50),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: _togglePause,
                        customBorder: const CircleBorder(),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Center(
                            child: Icon(
                              Icons.pause_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Pause overlay
              if (_isPaused)
                PauseOverlay(game: _myGame, onResume: _togglePause),

              // Confetti celebration overlay
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(isStopped: !_duringCelebration),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();
    final audioController = context.read<AudioController>();
    final game = widget.level;
    _myGame = MyGame(audioController: audioController, gamelevel: game);

    // Wire up the game-over callback to navigate to the score screen
    _myGame.onGameOver = _onGameOver;

    // Refresh the score display ~15 times per second
    _scoreTimer = Timer.periodic(const Duration(milliseconds: 66), (_) {
      if (mounted) setState(() {});
    });

    final adsController = context.read<AdsController?>();
    adsController?.preloadAd();
  }

  @override
  void dispose() {
    _scoreTimer?.cancel();
    super.dispose();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      _myGame.paused = _isPaused;
    });
  }

  /// Called by MyGame when the player collides with a pipe
  void _onGameOver() {
    // Small delay so the player sees the crash, then navigate
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final duration = Duration(seconds: _myGame.elapsedTime.toInt());
      final score = Score(
        widget.level.number,
        _myGame.score, // pipe-passing count used as difficulty for score calc
        duration,
      );

      final playerProgress = context.read<PlayerProgress>();
      playerProgress.addScore(score);

      GoRouter.of(context).go('/play/won', extra: {'score': score});
    });
  }

  /// Format elapsed seconds into MM:SS
  String _formatTime(double totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds.toInt() % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _playerWon() async {
    _log.info('Level ${widget.level.number} won');

    final score = Score(
      widget.level.number,
      widget.level.difficulty,
      DateTime.now().difference(_startOfPlay),
    );

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    playerProgress.addScore(score);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}
