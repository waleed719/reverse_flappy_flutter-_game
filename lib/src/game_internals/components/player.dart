import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'pipe.dart';
import '../my_game.dart';

class Player extends SpriteComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  double velocity = 0;
  double get gravity => game.gamelevel.gravity;
  double get jumpForce => game.gamelevel.jumpForce;
  Vector2 get playerSize => game.gamelevel.playerSize;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await game.loadSprite(game.gamelevel.playerSprites[0]);

    const double hitPadx = 7;
    const double hitPadY = 7;

    size = playerSize;
    anchor = Anchor.center;
    position = Vector2(game.virtualSize.x - 80, game.virtualSize.y / 2);
    add(
      RectangleHitbox(
        position: Vector2(hitPadx, hitPadY),
        size: Vector2(size.x - hitPadx * 2, size.y - hitPadY * 2),
      ),
    );
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
    if (position.y < 0 + size.y / 2) {
      position.y = 0 + size.y / 2;
      velocity = 0;
    }
    if (position.y > game.virtualSize.y - size.y / 2) {
      position.y = game.virtualSize.y - size.y / 2;
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
