// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Uncomment the following lines when enabling Firebase Crashlytics
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
// import 'firebase_options.dart';

import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:reverse_flappy/src/routes/approutes.dart';

import 'src/ads/ads_controller.dart';
import 'src/app_lifecycle/app_lifecycle.dart';
import 'src/audio/audio_controller.dart';
import 'src/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'src/player_progress/persistence/player_progress_persistence.dart';
import 'src/player_progress/player_progress.dart';
import 'src/settings/persistence/local_storage_settings_persistence.dart';
import 'src/settings/persistence/settings_persistence.dart';
import 'src/settings/settings.dart';
import 'src/style/palette.dart';
import 'src/style/snack_bar.dart';

Future<void> main() async {
  // Subscribe to log messages.
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // TODO: To enable Firebase Crashlytics, uncomment the following line.
  // See the 'Crashlytics' section of the main README.md file for details.

  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   try {
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //
  //     FlutterError.onError = (errorDetails) {
  //       FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  //     };
  //
  //     // Pass all uncaught asynchronous errors
  //     // that aren't handled by the Flutter framework to Crashlytics.
  //     PlatformDispatcher.instance.onError = (error, stack) {
  //       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //       return true;
  //     };
  //   } catch (e) {
  //     debugPrint("Firebase couldn't be initialized: $e");
  //   }
  // }

  _log.info('Going full screen');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // TODO: When ready, uncomment the following lines to enable integrations.
  //       Read the README for more info on each integration.

  AdsController? adsController;
  // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //   /// Prepare the google_mobile_ads plugin so that the first ad loads
  //   /// faster. This can be done later or with a delay if startup
  //   /// experience suffers.
  //   adsController = AdsController(MobileAds.instance);
  //   adsController.initialize();
  // }

  runApp(
    MyApp(
      settingsPersistence: LocalStorageSettingsPersistence(),
      playerProgressPersistence: LocalStoragePlayerProgressPersistence(),
      adsController: adsController,
    ),
  );
}

Logger _log = Logger('main.dart');

class MyApp extends StatelessWidget {
  final PlayerProgressPersistence playerProgressPersistence;

  final SettingsPersistence settingsPersistence;

  final AdsController? adsController;

  const MyApp({
    required this.playerProgressPersistence,
    required this.settingsPersistence,
    required this.adsController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              var progress = PlayerProgress(playerProgressPersistence);
              progress.getLatestScores();
              return progress;
            },
          ),
          Provider<AdsController?>.value(value: adsController),
          Provider<SettingsController>(
            lazy: false,
            create: (context) =>
                SettingsController(persistence: settingsPersistence)
                  ..loadStateFromPersistence(),
          ),
          ProxyProvider2<
            SettingsController,
            ValueNotifier<AppLifecycleState>,
            AudioController
          >(
            // Ensures that the AudioController is created on startup,
            // and not "only when it's needed", as is default behavior.
            // This way, music starts immediately.
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifecycleNotifier(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
          Provider(create: (context) => Palette()),
        ],
        child: Builder(
          builder: (context) {
            final palette = context.watch<Palette>();

            return MaterialApp.router(
              title: 'Reverse Flappy',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: palette.primaryYellow,
                  surface: palette.backgroundMain,
                ),
                textTheme: GoogleFonts.beVietnamProTextTheme(
                  ThemeData.light().textTheme,
                ).apply(bodyColor: palette.ink, displayColor: palette.ink),
                useMaterial3: true,
              ),
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              scaffoldMessengerKey: scaffoldMessengerKey,
            );
          },
        ),
      ),
    );
  }
}
