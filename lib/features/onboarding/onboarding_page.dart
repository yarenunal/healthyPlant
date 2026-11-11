import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/notification_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/playful_backdrop.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounce;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _bounce = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue({required bool enableReminders}) async {
    if (_busy) return;
    setState(() => _busy = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);

    if (enableReminders) {
      await NotificationService.instance.requestPermission();
    }
    await prefs.setBool('reminders_enabled', enableReminders);

    if (!mounted) return;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: PlayfulBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                AnimatedBuilder(
                  animation: _bounce,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -10 * _bounce.value),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.foam.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: AppColors.butter,
                        width: 3,
                      ),
                    ),
                    child: const SproutBuddy(size: 160),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.onboardingTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.onboardingSubtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mute,
                    height: 1.45,
                  ),
                ),
                const Spacer(flex: 3),
                ElevatedButton(
                  onPressed: _busy
                      ? null
                      : () => _continue(enableReminders: true),
                  child: Text(_busy ? l10n.pleaseWait : l10n.getStarted),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _continue(enableReminders: false),
                  child: Text(
                    l10n.continueWithoutReminders,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      color: AppColors.mute,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.onboardingPrivacyNote,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mute,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
