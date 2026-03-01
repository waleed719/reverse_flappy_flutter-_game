import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reverse_flappy/src/level_selection/level_selection_screen.dart';
import 'package:reverse_flappy/src/level_selection/levels.dart';
import 'package:reverse_flappy/src/main_menu/main_menu_screen.dart';
import 'package:reverse_flappy/src/play_session/play_session_screen.dart';
import 'package:reverse_flappy/src/player_progress/score.dart';
import 'package:reverse_flappy/src/scoreboard/score_board.dart';
import 'package:reverse_flappy/src/settings/settings_screen.dart';
import 'package:reverse_flappy/src/style/my_transition.dart';
import 'package:reverse_flappy/src/style/palette.dart';
import 'package:reverse_flappy/src/win_game/win_game_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: UniqueKey(),
            child: const LevelSelectionScreen(key: Key('level selection')),
            color: context.watch<Palette>().backgroundLevelSelection,
          ),
          routes: [
            GoRoute(
              path: 'session/:level',
              pageBuilder: (context, state) {
                final levelNumber = int.parse(state.pathParameters['level']!);
                final level = gameLevels.singleWhere(
                  (e) => e.number == levelNumber,
                );
                return buildMyTransition<void>(
                  key: ValueKey('level'),
                  child: PlaySessionScreen(
                    level,
                    key: const Key('play session'),
                  ),
                  color: context.watch<Palette>().backgroundPlaySession,
                );
              },
            ),
            GoRoute(
              path: 'won',
              redirect: (context, state) {
                if (state.extra == null) {
                  // Trying to navigate to a win screen without any data.
                  // Possibly by using the browser's back button.
                  return '/';
                }

                // Otherwise, do not redirect.
                return null;
              },
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final score = map['score'] as Score;

                return buildMyTransition<void>(
                  key: ValueKey('won'),
                  child: WinGameScreen(
                    score: score,
                    key: const Key('win game'),
                  ),
                  color: context.watch<Palette>().backgroundPlaySession,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: 'scoreboard',
          builder: (context, state) =>
              const ScoreboardScreen(key: Key('scoreboard')),
        ),
      ],
    ),
  ],
);
