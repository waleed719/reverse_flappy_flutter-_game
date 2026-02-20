import 'dart:math';

import 'package:flame/components.dart';

class CameraShake extends Component {
  final CameraComponent cameraComponent;
  final double intensity;
  final double duration;
  double _elapsed = 0;

  CameraShake({
    required this.cameraComponent,
    required this.intensity,
    required this.duration,
  });

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= duration) {
      // Reset viewport back to origin and remove this component
      cameraComponent.viewport.position = Vector2.zero();
      removeFromParent();
      return;
    }

    // Decay the shake intensity over time for a natural feel
    final double progress = _elapsed / duration;
    final double currentIntensity = intensity * (1.0 - progress);

    final double frequency = 30.0;
    final double offsetX = sin(_elapsed * frequency) * currentIntensity;
    final double offsetY = cos(_elapsed * frequency) * currentIntensity;

    cameraComponent.viewport.position = Vector2(offsetX, offsetY);
  }
}
