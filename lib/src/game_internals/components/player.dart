import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'pipe.dart';
import '../my_game.dart';

class Player extends SpriteComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  double velocity = 0;
  final double gravity = -850; // Adjusted gravity for better feel
  final double jumpForce = 350; // Positive force moves down

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await game.loadSprite('player.png');
    size = Vector2(64, 64);
    anchor = Anchor.center;
    position = Vector2(game.size.x - 80, game.size.y / 2);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (game.isGameOver) return;
    super.update(dt);

    velocity += gravity * dt;
    position.y += velocity * dt;

    // Optional: Add rotation based on velocity for visual feedback
    angle = velocity * 0.002;

    // Screen bounds check (keep inside screen vertically)
    if (position.y < 0) {
      position.y = 0;
      velocity = 0;
    }
    if (position.y > game.size.y - size.y) {
      position.y = game.size.y - size.y;
      velocity = 0;
    }
  }

  void fly() {
    if (game.isGameOver) return;
    velocity = jumpForce;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe) {
      game.gameOver(); // all game-over logic is centralized in MyGame
    }
  }
}
