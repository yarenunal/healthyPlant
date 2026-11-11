import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/plant_store.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'home/home_page.dart';
import 'my_plants/my_plants_page.dart';
import 'scan/scan_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.store});

  final PlantStore store;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  bool _bannerChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowOverdueBanner());
  }

  Future<void> _maybeShowOverdueBanner() async {
    if (_bannerChecked || !mounted) return;
    _bannerChecked = true;

    final overdue = widget.store.overduePlants;
    if (overdue.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final key =
        'overdue_banner_${today.year}-${today.month}-${today.day}';
    if (prefs.getBool(key) ?? false) return;
    if (!mounted) return;

    final l10n = AppLocalizations.of(context);
    final names = overdue.take(3).map((p) => p.nickname).join(', ');
    final namesLabel = overdue.length > 3 ? '$names…' : names;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.foam,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            l10n.overdueBannerTitle,
            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
          ),
          content: Text(
            l10n.overdueBannerBody(namesLabel),
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await prefs.setBool(key, true);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.overdueBannerLater),
            ),
            ElevatedButton(
              onPressed: () async {
                await prefs.setBool(key, true);
                if (context.mounted) Navigator.pop(context);
                setState(() => _index = 1);
              },
              child: Text(l10n.overdueBannerOpen),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openScanner() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ScanPage(store: widget.store),
      ),
    );
    if (added == true && mounted) {
      setState(() => _index = 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      HomePage(
        store: widget.store,
        onOpenScanner: _openScanner,
        onOpenMyPlants: () => setState(() => _index = 1),
      ),
      MyPlantsPage(store: widget.store),
    ];

    return Scaffold(
      backgroundColor: AppColors.blush,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.foam,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.cloudPink.withValues(alpha: 0.8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SoftNavButton(
                  icon: Icons.cottage_outlined,
                  activeIcon: Icons.cottage_rounded,
                  label: l10n.navHome,
                  selected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Material(
                  color: AppColors.butter,
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: _openScanner,
                    borderRadius: BorderRadius.circular(22),
                    child: const SizedBox(
                      width: 58,
                      height: 58,
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.ink,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _SoftNavButton(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: l10n.navMyPlants,
                  selected: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoftNavButton extends StatelessWidget {
  const _SoftNavButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.cloudPink.withValues(alpha: 0.55)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? AppColors.mossDeep : AppColors.mute,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.ink : AppColors.mute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
