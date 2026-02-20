const gameLevels = [
  GameLevel(
    number: 1,
    difficulty: 5,
    worldName: 'Whispering Woods',
    worldSubtitle: 'A calm forest to start your journey',
    worldIcon: '🌲',
    worldColor: 0xFF4CAF50,
    achievementIdIOS: 'first_win',
    achievementIdAndroid: 'NhkIwB69ejkMAOOLDb',
  ),
  GameLevel(
    number: 2,
    difficulty: 42,
    worldName: 'Neon Skyline',
    worldSubtitle: 'Navigate the dazzling city lights',
    worldIcon: '🌆',
    worldColor: 0xFF00BCD4,
  ),
  GameLevel(
    number: 3,
    difficulty: 100,
    worldName: 'Galactic Void',
    worldSubtitle: 'Survive the depths of space',
    worldIcon: '🌌',
    worldColor: 0xFF7C4DFF,
    achievementIdIOS: 'finished',
    achievementIdAndroid: 'CdfIhE96aspNWLGSQg',
  ),
];

class GameLevel {
  final int number;
  final int difficulty;
  final String worldName;
  final String worldSubtitle;
  final String worldIcon;
  final int worldColor;
  final String? achievementIdIOS;
  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.difficulty,
    this.worldName = 'World',
    this.worldSubtitle = '',
    this.worldIcon = '🎮',
    this.worldColor = 0xFF4CAF50,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
         (achievementIdAndroid != null && achievementIdIOS != null) ||
             (achievementIdAndroid == null && achievementIdIOS == null),
         'Either both iOS and Android achievement ID must be provided, '
         'or none',
       );
}
