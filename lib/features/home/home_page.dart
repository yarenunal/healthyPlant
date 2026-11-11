import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/catalog.dart';
import '../../data/locale_controller.dart';
import '../../data/notification_service.dart';
import '../../data/plant_store.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/playful_backdrop.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.store,
    required this.onOpenScanner,
    required this.onOpenMyPlants,
  });

  final PlantStore store;
  final VoidCallback onOpenScanner;
  final VoidCallback onOpenMyPlants;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _remindersEnabled = true;
  bool _loadedPrefs = false;
  int _reminderHour = 9;
  int _reminderMinute = 0;

  String get _timeLabel =>
      '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = await NotificationService.instance.getReminderHour();
    final minute = await NotificationService.instance.getReminderMinute();
    if (!mounted) return;
    setState(() {
      _remindersEnabled = prefs.getBool('reminders_enabled') ?? false;
      _reminderHour = hour;
      _reminderMinute = minute;
      _loadedPrefs = true;
    });
  }

  Future<void> _enableReminders() async {
    final l10n = AppLocalizations.of(context);
    final granted = await NotificationService.instance.requestPermission();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminders_enabled', granted);
    await NotificationService.instance.rescheduleAll(widget.store.plants);
    if (!mounted) return;
    setState(() => _remindersEnabled = granted);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? l10n.remindersEnabledSnack(_timeLabel)
              : l10n.remindersPermissionSnack,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openSettings() async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.foam,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.settings,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.language,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _ChoiceChip(
                      label: l10n.languageSystem,
                      selected: LocaleController.instance.locale == null,
                      onTap: () async {
                        await LocaleController.instance.setLocale(null);
                        await NotificationService.instance
                            .rescheduleAll(widget.store.plants);
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                    _ChoiceChip(
                      label: l10n.languageEnglish,
                      selected:
                          LocaleController.instance.locale?.languageCode ==
                              'en',
                      onTap: () async {
                        await LocaleController.instance
                            .setLocale(const Locale('en'));
                        await NotificationService.instance
                            .rescheduleAll(widget.store.plants);
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                    _ChoiceChip(
                      label: l10n.languageTurkish,
                      selected:
                          LocaleController.instance.locale?.languageCode ==
                              'tr',
                      onTap: () async {
                        await LocaleController.instance
                            .setLocale(const Locale('tr'));
                        await NotificationService.instance
                            .rescheduleAll(widget.store.plants);
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  l10n.reminderTimeTitle,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.reminderTimeSubtitle(_timeLabel),
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: AppColors.mute,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _pickReminderTime();
                  },
                  icon: const Icon(Icons.schedule_rounded),
                  label: Text(l10n.changeTime),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickReminderTime() async {
    final l10n = AppLocalizations.of(context);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _reminderHour, minute: _reminderMinute),
      helpText: l10n.reminderTimeTitle,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.mossDeep,
                  secondary: AppColors.butter,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null || !mounted) return;

    await NotificationService.instance.setReminderTime(
      hour: picked.hour,
      minute: picked.minute,
    );
    await NotificationService.instance.rescheduleAll(widget.store.plants);

    if (!mounted) return;
    setState(() {
      _reminderHour = picked.hour;
      _reminderMinute = picked.minute;
    });

    final label =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.reminderTimeSaved(label)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final turkish = LocaleController.instance.isTurkish;

    return PlayfulBackdrop(
      child: SafeArea(
        child: ListenableBuilder(
          listenable: widget.store,
          builder: (context, _) {
            final thirsty = widget.store.thirstyCount;
            final status = thirsty == 0
                ? l10n.homeAllFine
                : thirsty == 1
                    ? l10n.homeNeedsWater(thirsty)
                    : l10n.homeNeedsWaterPlural(thirsty);

            return ListView(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.homeTitle,
                        style: GoogleFonts.nunito(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.settings,
                      onPressed: _openSettings,
                      icon: const Icon(Icons.settings_rounded),
                      color: AppColors.mossDeep,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: thirsty == 0 ? AppColors.mossDeep : AppColors.berry,
                  ),
                ),
                if (_loadedPrefs) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.reminderTimeSubtitle(_timeLabel),
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mute,
                    ),
                  ),
                ],
                if (widget.store.overdueCount > 0) ...[
                  const SizedBox(height: 16),
                  _OverdueSummaryCard(
                    count: widget.store.overdueCount,
                    names: widget.store.overduePlants
                        .take(3)
                        .map((p) => p.nickname)
                        .toList(),
                    onOpen: widget.onOpenMyPlants,
                  ),
                ],
                if (_loadedPrefs && !_remindersEnabled) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.butter.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.enableRemindersPrompt,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _enableReminders,
                          child: Text(
                            l10n.enable,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              color: AppColors.mossDeep,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: widget.onOpenScanner,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.softSky.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.softSky,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.foam,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 30,
                            color: AppColors.mossDeep,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.scanPlantCardTitle,
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.scanPlantCardSubtitle,
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mute,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  l10n.quickCareGuide,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: PlantCatalog.plants.take(4).map((plant) {
                    final colors = [
                      AppColors.cloudPink,
                      AppColors.butter,
                      AppColors.softSky,
                      AppColors.lilacWash,
                    ];
                    final color = colors[
                        PlantCatalog.plants.indexOf(plant) % colors.length];
                    return Container(
                      width: (MediaQuery.sizeOf(context).width - 54) / 2,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plant.displayName(turkish: turkish),
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.everyNDays(plant.wateringDays),
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mute,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.butter,
      labelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
    );
  }
}

class _OverdueSummaryCard extends StatelessWidget {
  const _OverdueSummaryCard({
    required this.count,
    required this.names,
    required this.onOpen,
  });

  final int count;
  final List<String> names;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = count == 1
        ? l10n.overdueSummaryTitle(count)
        : l10n.overdueSummaryTitlePlural(count);
    final namesLine = names.join(', ');

    return Material(
      color: AppColors.berry.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.berry.withValues(alpha: 0.55),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.water_drop_outlined,
                    color: AppColors.berry,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.berry,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                namesLine,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.overdueSummarySubtitle,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.mute,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l10n.viewOverdue,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                    color: AppColors.mossDeep,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
