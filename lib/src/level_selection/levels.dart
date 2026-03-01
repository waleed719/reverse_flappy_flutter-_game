import 'package:flame/components.dart';
import 'package:reverse_flappy/src/game_internals/models/world_config.dart';

final gameLevels = [
  GameLevel(
    id: 1,
    name: 'Whispering Woods',
    backgroundSprites: const ['world1.png', 'world1.png'],
    playerSprites: const ['player.png'],
    pipeSprites: const [
      'forest_pipe/top.png',
      'forest_pipe/middle.png',
      'forest_pipe/bottom.png',
    ],
    gravity: -850,
    baseVelocity: 155,
    jumpForce: 350,
    pipeGapHeight: 150,
    spawnInterval: 3.5,
    scoreToUnlock: 0,
    speedIncreasePerScore: 10,
    number: 1,
    difficulty: 2,
    playerSize: Vector2(64, 64),
  ),
  GameLevel(
    id: 2,
    name: 'Frostfall Valley',
    backgroundSprites: [
      'frost.png',
      'frost.png',
    ], // Placeholder, you should add your own assets
    playerSprites: ['frost_dragon.png'], // Placeholder
    pipeSprites: [
      'frost_pipe/top.png',
      'frost_pipe/middle.png',
      'frost_pipe/bottom.png',
    ],
    gravity: -900, // Slightly faster fall
    baseVelocity: 180, // Faster forward movement
    jumpForce: 380, // Stronger jump
    pipeGapHeight: 150, // Tighter gaps
    spawnInterval: 3.2, // Faster spawning
    scoreToUnlock: 5000, // Unlocks after getting a score of 10
    speedIncreasePerScore: 12,
    number: 2,
    difficulty: 42,
    worldName: 'Frostfall Valley',
    worldSubtitle: 'Navigate the frozen peaks of Frostfall Valley',
    worldIcon: '❄️',
    worldColor: 0xFF00BCD4,
    playerSize: Vector2(84, 84),
  ),
  GameLevel(
    id: 3,
    name: 'Molten Horizen',
    backgroundSprites: [
      'lava.png',
      'lava.png',
    ], // Placeholder, you should add your own assets
    playerSprites: ['dragon.png'], // Placeholder
    pipeSprites: [
      'lava_pipe/top.png',
      'lava_pipe/middle.png',
      'lava_pipe/bottom.png',
    ],
    gravity: -900, // Slightly faster fall
    baseVelocity: 180, // Faster forward movement
    jumpForce: 380, // Stronger jump
    pipeGapHeight: 150, // Tighter gaps
    spawnInterval: 3.2, // Faster spawning
    scoreToUnlock: 10000, // Unlocks after getting a score of 10
    speedIncreasePerScore: 12,
    number: 3,
    difficulty: 42,
    worldName: 'Molten Horizen',
    worldSubtitle: 'Navigate the burning Heat of Lava Mountains',
    worldIcon: '🌋',
    worldColor: 0xFF00BCD4,
    playerSize: Vector2(120, 120),
  ),
];

class GameLevel extends WorldConfig {
  final int number;
  final int difficulty;
  final String worldName;
  final String worldSubtitle;
  final String worldIcon;
  final int worldColor;
  final String? achievementIdIOS;
  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.difficulty,
    this.worldName = 'World',
    this.worldSubtitle = '',
    this.worldIcon = '🎮',
    this.worldColor = 0xFF4CAF50,
    this.achievementIdIOS,
    this.achievementIdAndroid,
    required super.id,
    required super.name,
    required super.backgroundSprites,
    required super.playerSprites,
    required super.pipeSprites,
    required super.gravity,
    required super.baseVelocity,
    required super.jumpForce,
    required super.pipeGapHeight,
    required super.spawnInterval,
    required super.scoreToUnlock,
    required super.speedIncreasePerScore,
    required super.playerSize,
  }) : assert(
         (achievementIdAndroid != null && achievementIdIOS != null) ||
             (achievementIdAndroid == null && achievementIdIOS == null),
         'Either both iOS and Android achievement ID must be provided, '
         'or none',
       );
}
