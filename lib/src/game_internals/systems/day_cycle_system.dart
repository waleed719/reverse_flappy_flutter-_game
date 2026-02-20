import 'package:flame/components.dart';

import '../components/background_component.dart';

class DayCycleSystem extends Component {
  final BackgroundComponent background;
  double distanceTraveled = 0;
  final double sceneChangeDistance = 2000;
  DayCycleSystem(this.background);

  @override
  void update(double dt) {
    super.update(dt);
    distanceTraveled += 50 * dt;
    if (distanceTraveled >= sceneChangeDistance) {
      // background.changeScene();
      distanceTraveled = 0;
    }
  }
}
