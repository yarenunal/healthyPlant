import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/catalog.dart';
import '../../data/locale_controller.dart';
import '../../data/models.dart';
import '../../data/plant_store.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../widgets/playful_backdrop.dart';

class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key, required this.store});

  final PlantStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final turkish = LocaleController.instance.isTurkish;

    return PlayfulBackdrop(
      child: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            if (store.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.mossDeep),
              );
            }

            final count = store.plants.length;
            final subtitle = store.plants.isEmpty
                ? l10n.myPlantsEmptyHint
                : count == 1
                    ? l10n.plantsSaved(count)
                    : l10n.plantsSavedPlural(count);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.myPlantsTitle,
                        style: GoogleFonts.nunito(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mute,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: store.plants.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SproutBuddy(size: 120),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noPlantsYet,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mute,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
                          itemCount: store.plants.length,
                          itemBuilder: (context, index) {
                            final plant = store.plants[index];
                            final catalog =
                                PlantCatalog.byId(plant.catalogId);
                            return _PlantCard(
                              plant: plant,
                              catalog: catalog,
                              turkish: turkish,
                              onWatered: () => store.markWatered(plant.id),
                              onDelete: () => store.remove(plant.id),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  const _PlantCard({
    required this.plant,
    required this.catalog,
    required this.turkish,
    required this.onWatered,
    required this.onDelete,
  });

  final UserPlant plant;
  final CatalogPlant? catalog;
  final bool turkish;
  final VoidCallback onWatered;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overdue = plant.isOverdue;
    final needsWater = plant.needsWaterToday;
    final canWater = overdue || needsWater;
    final statusText = overdue
        ? l10n.needsWater
        : needsWater
            ? l10n.waterToday
            : l10n.nextWaterInDays(plant.daysUntilWater);

    final Color buttonBg;
    final Color buttonFg;
    final String buttonLabel;
    if (!canWater) {
      buttonBg = AppColors.softMoss;
      buttonFg = Colors.white;
      buttonLabel = l10n.wateredLabel;
    } else if (overdue) {
      buttonBg = AppColors.berry;
      buttonFg = Colors.white;
      buttonLabel = l10n.waterNow;
    } else {
      buttonBg = AppColors.butter;
      buttonFg = AppColors.ink;
      buttonLabel = l10n.iWateredIt;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: overdue
            ? AppColors.berry.withValues(alpha: 0.12)
            : AppColors.foam.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: overdue
              ? AppColors.berry.withValues(alpha: 0.7)
              : needsWater
                  ? AppColors.butter
                  : AppColors.softMoss.withValues(alpha: 0.45),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 74,
                  height: 74,
                  child: plant.photoPath != null &&
                          File(plant.photoPath!).existsSync()
                      ? Image.file(File(plant.photoPath!), fit: BoxFit.cover)
                      : ColoredBox(
                          color: AppColors.lilacWash.withValues(alpha: 0.7),
                          child: Center(
                            child: Text(
                              catalog?.emoji ?? '🌿',
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.nickname,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (catalog != null)
                      Text(
                        catalog!.displayName(turkish: turkish),
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mute,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: overdue
                            ? AppColors.berry.withValues(alpha: 0.15)
                            : needsWater
                                ? AppColors.butter.withValues(alpha: 0.55)
                                : AppColors.softMoss.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: overdue
                              ? AppColors.berry
                              : needsWater
                                  ? AppColors.ink
                                  : AppColors.mossDeep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.close_rounded),
                color: AppColors.mute,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canWater ? onWatered : null,
              style: FilledButton.styleFrom(
                backgroundColor: buttonBg,
                foregroundColor: buttonFg,
                disabledBackgroundColor: AppColors.softMoss,
                disabledForegroundColor: Colors.white,
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
