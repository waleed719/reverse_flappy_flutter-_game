// import 'dart:ui';

import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:reverse_flappy/src/audio/audio_controller.dart';
import 'package:reverse_flappy/src/audio/sounds.dart';

import 'game_world.dart';
import 'systems/camera_shake.dart';

class MyGame extends FlameGame
    with TapCallbacks, KeyboardEvents, HasCollisionDetection {
  final AudioController audioController;
  late final GameWorld myworld;
  late final CameraComponent cameraComponent;

  double worldSpeed = 150;
  bool isGameOver = false;
  int score = 0;
  double elapsedTime = 0; // seconds since game started

  Vector2 get virtualSize => size / cameraComponent.viewfinder.zoom;

  MyGame({required this.audioController});

  /// Callback that the Flutter widget layer sets so we can
  /// notify it when the game ends (e.g. to navigate to a score screen).
  VoidCallback? onGameOver;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    myworld = GameWorld();
    cameraComponent = CameraComponent(world: myworld);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      cameraComponent.viewfinder.zoom = 0.8;
    } else {
      cameraComponent.viewfinder.zoom = 1.0;
    }

    add(myworld);
    add(cameraComponent);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    audioController.playSfx(SfxType.buttonTap);
    myworld.player.fly();
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace) {
      myworld.player.fly();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void update(double dt) {
    super.update(
      dt,
    ); // Must run first so child components (e.g. CameraShake) update
    if (isGameOver) return;
    elapsedTime += dt;
    worldSpeed += dt * 10;
    myworld.pipeSpawner.update(dt);
  }

  void onPlayerDeath() {
    add(
      CameraShake(cameraComponent: cameraComponent, intensity: 20, duration: 2),
    );
  }

  void gameOver() {
    if (isGameOver) return; // prevent calling twice
    isGameOver = true;
    worldSpeed = 0.0;
    onGameOver?.call();
    onPlayerDeath();
  }
}
