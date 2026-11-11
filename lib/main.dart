import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/locale_controller.dart';
import 'data/notification_service.dart';
import 'data/plant_store.dart';
import 'features/main_shell.dart';
import 'features/onboarding/onboarding_page.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  await LocaleController.instance.load();

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;
  final store = PlantStore();
  await store.load();

  runApp(HealthyPlantApp(showOnboarding: !onboardingDone, store: store));
}

class HealthyPlantApp extends StatefulWidget {
  const HealthyPlantApp({
    super.key,
    required this.showOnboarding,
    required this.store,
  });

  final bool showOnboarding;
  final PlantStore store;

  @override
  State<HealthyPlantApp> createState() => _HealthyPlantAppState();
}

class _HealthyPlantAppState extends State<HealthyPlantApp> {
  late bool _showOnboarding = widget.showOnboarding;
  final _localeController = LocaleController.instance;

  @override
  void initState() {
    super.initState();
    _localeController.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    _localeController.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: _localeController.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _showOnboarding
          ? OnboardingPage(
              onFinished: () => setState(() => _showOnboarding = false),
            )
          : MainShell(store: widget.store),
    );
  }
}
