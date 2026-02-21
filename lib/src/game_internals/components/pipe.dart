import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'player.dart';
import '../my_game.dart';

class Pipe extends PositionComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  final double gapY;
  final double gapHeight;

  bool _scored = false;

  Pipe({required this.gapY, required this.gapHeight});

  @override
  Future<void> onLoad() async {
    final pipeSprite = await game.loadSprite('pipe.png');
    final double pipeWidth = 60;

    // How much to shrink hitboxes for more forgiving collisions
    const double hitPadX = 12; // pixels smaller on each side horizontally
    const double hitPadY = 12; // pixels smaller on each end vertically

    final double topHeight = gapY - gapHeight / 2;
    final double bottomY = gapY + gapHeight / 2;
    final double bottomHeight = game.virtualSize.y - bottomY;

    // Calculate natural tile height from the sprite's aspect ratio
    final double spriteAspect = pipeSprite.srcSize.y / pipeSprite.srcSize.x;
    final double tileHeight = pipeWidth * spriteAspect;

    // --- Top pipe (tiled, flipped) ---
    // Stack repeated sprite tiles going upward from the gap
    double yPos = topHeight;
    while (yPos > 0) {
      final double h = yPos < tileHeight ? yPos : tileHeight;
      add(
        SpriteComponent(
          sprite: pipeSprite,
          size: Vector2(pipeWidth, h),
          position: Vector2(0, yPos),
          scale: Vector2(1, -1), // flip vertically
        ),
      );
      yPos -= tileHeight;
    }

    // --- Bottom pipe (tiled, normal) ---
    double bPos = bottomY;
    while (bPos < game.virtualSize.y) {
      final double remaining = game.virtualSize.y - bPos;
      final double h = remaining < tileHeight ? remaining : tileHeight;
      add(
        SpriteComponent(
          sprite: pipeSprite,
          size: Vector2(pipeWidth, h),
          position: Vector2(0, bPos),
        ),
      );
      bPos += tileHeight;
    }

    // --- Hitboxes (slightly smaller than visuals for fair collisions) ---
    // Top hitbox
    if (topHeight > hitPadY * 2) {
      add(
        RectangleHitbox(
          position: Vector2(hitPadX, hitPadY),
          size: Vector2(pipeWidth - hitPadX * 2, topHeight - hitPadY * 2),
        ),
      );
    }

    // Bottom hitbox
    if (bottomHeight > hitPadY * 2) {
      add(
        RectangleHitbox(
          position: Vector2(hitPadX, bottomY + hitPadY),
          size: Vector2(pipeWidth - hitPadX * 2, bottomHeight - hitPadY * 2),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move from left to right
    position.x += game.worldSpeed * dt;

    // Remove when off-screen to the right
    if (position.x > game.virtualSize.x + 60) {
      removeFromParent();
    }

    // Score when the pipe passes the player's x position
    if (!_scored && position.x > game.myworld.player.position.x) {
      _scored = true;
      game.score++;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      game.gameOver();
    }
  }
}
