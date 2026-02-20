import 'package:flame/components.dart';

import '../my_game.dart';

class BackgroundComponent extends PositionComponent
    with HasGameReference<MyGame> {
  final List<String> scenes = ["world1.png", "world2.png"];
  late List<Sprite> _loadedSprites;

  late SpriteComponent _bg1;
  late SpriteComponent _bg2;

  int _sceneIndex = 0;
  final double _scrollSpeed = 150;
  final double overlap = 0.5;

  @override
  Future<void> onLoad() async {
    size = game.size;
    anchor = Anchor.topLeft;
    position = Vector2.zero();
    priority = -1;

    _loadedSprites = await Future.wait(scenes.map((e) => game.loadSprite(e)));

    _bg1 = SpriteComponent(
      sprite: _loadedSprites[0],
      size: size,
      position: Vector2.zero(),
    );

    _bg2 = SpriteComponent(
      sprite: _loadedSprites[1],
      size: size,
      position: Vector2(-size.x + overlap, 0),
    );

    add(_bg1);
    add(_bg2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameOver) {
      return;
    }

    final moveAmount = _scrollSpeed * dt;

    _bg1.x += moveAmount;
    _bg2.x += moveAmount;

    if (_bg1.x > size.x) {
      _moveToLeft(_bg1);
    }

    if (_bg2.x > size.x) {
      _moveToLeft(_bg2);
    }
  }

  void _moveToLeft(SpriteComponent bg) {
    final other = bg == _bg1 ? _bg2 : _bg1;

    bg.x = other.x - size.x + overlap;

    bg.sprite = _loadedSprites[_sceneIndex];

    _sceneIndex = (_sceneIndex + 1) % _loadedSprites.length;
  }
}
