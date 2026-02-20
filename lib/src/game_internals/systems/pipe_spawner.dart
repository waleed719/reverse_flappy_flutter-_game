import 'dart:math';

import 'package:flame/components.dart';

import '../components/pipe.dart';
import '../my_game.dart';

class PipeSpawner extends Component with HasGameReference<MyGame> {
  final double spawnInterval = 3.5; // seconds
  double _timer = 0;

  final Random _random = Random();

  /// The gap center of the last spawned pipe (for clamping movement)
  double? _lastGapY;

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameOver) return;

    _timer += dt;

    if (_timer >= spawnInterval) {
      _spawnPipe();
      _timer = 0;
    }
  }

  void _spawnPipe() {
    final double screenH = game.size.y;
    final double gapHeight = 200;

    // Minimum pipe height on either side (ensures both pipes are always visible)
    final double minPipeHeight = screenH * 0.15;

    // The gap center must be far enough from top/bottom so both pipes are visible
    // top pipe height = gapY - gapHeight/2, must be >= minPipeHeight
    // bottom pipe height = screenH - (gapY + gapHeight/2), must be >= minPipeHeight
    final double minGapY = minPipeHeight + gapHeight / 2;
    final double maxGapY = screenH - minPipeHeight - gapHeight / 2;

    // Random gap center within the allowed range
    double gapY = _random.nextDouble() * (maxGapY - minGapY) + minGapY;

    // Limit how far the gap can jump from the previous pipe
    // (prevents unfair sudden shifts, just like real Flappy Bird)
    const double maxJump = 120;
    if (_lastGapY != null) {
      gapY = gapY.clamp(_lastGapY! - maxJump, _lastGapY! + maxJump);
      // Re-clamp to valid range after jump limiting
      gapY = gapY.clamp(minGapY, maxGapY);
    }
    _lastGapY = gapY;

    final newPipe = Pipe(gapY: gapY, gapHeight: gapHeight)..position.x = -150;
    game.myworld.add(newPipe);
  }
}
