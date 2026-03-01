import 'package:flame/components.dart';

class WorldConfig {
  final int id;
  final String name;
  final List<String> backgroundSprites;
  final List<String> playerSprites;
  final List<String> pipeSprites;

  final double gravity;
  final double baseVelocity;
  final double jumpForce;
  final double pipeGapHeight;
  final double spawnInterval;
  final double scoreToUnlock;
  final double speedIncreasePerScore;
  final Vector2 playerSize;

  const WorldConfig({
    required this.id,
    required this.name,
    required this.backgroundSprites,
    required this.playerSprites,
    required this.pipeSprites,
    required this.gravity,
    required this.baseVelocity,
    required this.jumpForce,
    required this.pipeGapHeight,
    required this.spawnInterval,
    required this.scoreToUnlock,
    required this.speedIncreasePerScore,
    required this.playerSize,
  });
}
