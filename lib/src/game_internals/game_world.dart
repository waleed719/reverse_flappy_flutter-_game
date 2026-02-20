import 'package:flame/components.dart';

import 'systems/pipe_spawner.dart';
import 'components/player.dart';
import 'components/background_component.dart';

class GameWorld extends World {
  late final BackgroundComponent background;
  late final Player player;
  late final PipeSpawner pipeSpawner;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    background = BackgroundComponent();
    player = Player();
    pipeSpawner = PipeSpawner();
    add(background);
    add(player);
    add(pipeSpawner);
  }
}
