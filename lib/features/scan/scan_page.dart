import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/catalog.dart';
import '../../data/locale_controller.dart';
import '../../data/models.dart';
import '../../data/notification_service.dart';
import '../../data/plant_store.dart';
import '../../data/scan_quota.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.store});

  final PlantStore store;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _picker = ImagePicker();
  File? _photo;
  bool _analyzing = false;
  List<CatalogPlant> _suggestions = [];
  CatalogPlant? _selected;
  final _nicknameController = TextEditingController();
  final _searchController = TextEditingController();
  int _scansRemaining = ScanQuota.dailyLimit;

  bool get _turkish => LocaleController.instance.isTurkish;

  @override
  void initState() {
    super.initState();
    _refreshQuota();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshQuota() async {
    final remaining = await ScanQuota.instance.remainingToday();
    if (!mounted) return;
    setState(() => _scansRemaining = remaining);
  }

  Future<void> _onQuotaReached() async {
    final l10n = AppLocalizations.of(context);
    await NotificationService.instance.showScanQuotaLimitOnce();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.scanQuotaReachedSnack(ScanQuota.dailyLimit)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    final allowed = await ScanQuota.instance.canScan();
    if (!allowed) {
      await _refreshQuota();
      if (!mounted) return;
      await _onQuotaReached();
      return;
    }

    final xFile = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (xFile == null) return;

    // Consume after the user actually picks a photo (not on cancel).
    final consumed = await ScanQuota.instance.tryConsume();
    if (!consumed) {
      await _refreshQuota();
      if (!mounted) return;
      await _onQuotaReached();
      return;
    }
    await _refreshQuota();

    setState(() {
      _photo = File(xFile.path);
      _analyzing = true;
      _suggestions = [];
      _selected = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final guesses = await _runIdentification(_photo!);
    setState(() {
      _analyzing = false;
      _suggestions = guesses;
      _selected = guesses.isNotEmpty ? guesses.first : null;
      if (_selected != null) {
        _nicknameController.text =
            _selected!.displayName(turkish: _turkish);
      }
    });
  }

  Future<List<CatalogPlant>> _runIdentification(File photo) async {
    assert(photo.existsSync());
    return PlantCatalog.suggestFromScan();
  }

  Future<String> _persistPhoto(File source) async {
    final dir = await getApplicationDocumentsDirectory();
    final plantsDir = Directory(p.join(dir.path, 'plant_photos'));
    if (!plantsDir.existsSync()) {
      await plantsDir.create(recursive: true);
    }
    final target = File(
      p.join(plantsDir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg'),
    );
    return (await source.copy(target.path)).path;
  }

  Future<void> _save() async {
    final plant = _selected;
    if (plant == null) return;
    final nickname = _nicknameController.text.trim().isEmpty
        ? plant.displayName(turkish: _turkish)
        : _nicknameController.text.trim();

    String? savedPath;
    if (_photo != null) {
      savedPath = await _persistPhoto(_photo!);
    }

    await widget.store.addPlant(
      catalogId: plant.id,
      nickname: nickname,
      wateringDays: plant.wateringDays,
      photoPath: savedPath,
    );

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.plantAddedSnack(nickname)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF4A3F4A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          l10n.scanTitle,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_photo != null)
                      Image.file(_photo!, fit: BoxFit.cover)
                    else
                      ColoredBox(
                        color: AppColors.mossDeep.withValues(alpha: 0.4),
                        child: Center(
                          child: Text(
                            l10n.scanFrameHint,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    CustomPaint(painter: _LensFramePainter()),
                    if (_analyzing)
                      Container(
                        color: Colors.black45,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.butter,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.identifying,
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.foam,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: _photo == null
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _scansRemaining <= 0
                              ? () => _onQuotaReached()
                              : () => _pick(ImageSource.camera),
                          icon: const Icon(Icons.photo_camera_rounded),
                          label: Text(l10n.camera),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _scansRemaining <= 0
                              ? () => _onQuotaReached()
                              : () => _pick(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_rounded),
                          label: Text(l10n.gallery),
                        ),
                      ),
                    ],
                  )
                : _buildResultPanel(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildResultPanel(AppLocalizations l10n) {
    if (_analyzing) {
      return Text(
        l10n.pleaseWait,
        style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
      );
    }

    final searchResults = PlantCatalog.search(_searchController.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.possibleMatch,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _suggestions.map((plant) {
              final selected = _selected?.id == plant.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: selected,
                  label: Text(
                    '${plant.emoji} ${plant.displayName(turkish: _turkish)}',
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selected = plant;
                      _nicknameController.text =
                          plant.displayName(turkish: _turkish);
                    });
                  },
                  selectedColor: AppColors.butter,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.wrongPlantSearch,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (_searchController.text.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final plant = searchResults[index];
                return ListTile(
                  dense: true,
                  leading: Text(plant.emoji),
                  title: Text(plant.displayName(turkish: _turkish)),
                  subtitle: Text(plant.scientificName),
                  onTap: () {
                    setState(() {
                      _selected = plant;
                      _nicknameController.text =
                          plant.displayName(turkish: _turkish);
                      _searchController.clear();
                    });
                  },
                );
              },
            ),
          ),
        ],
        if (_selected != null) ...[
          const SizedBox(height: 10),
          _CareSummary(plant: _selected!, turkish: _turkish),
          const SizedBox(height: 10),
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(hintText: l10n.plantNickname),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _save,
            child: Text(l10n.addToMyPlants),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _photo = null;
                _suggestions = [];
                _selected = null;
              });
            },
            child: Text(l10n.retake),
          ),
        ],
      ],
    );
  }
}

class _CareSummary extends StatelessWidget {
  const _CareSummary({required this.plant, required this.turkish});

  final CatalogPlant plant;
  final bool turkish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${plant.emoji} ${plant.displayName(turkish: turkish)}',
            style: GoogleFonts.nunito(fontWeight: FontWeight.w900),
          ),
          Text(
            plant.scientificName,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.mute,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.careWaterLight(plant.wateringDays, plant.light),
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            plant.careTip(turkish: turkish),
            style: GoogleFonts.nunito(fontSize: 13, color: AppColors.mute),
          ),
        ],
      ),
    );
  }
}

class _LensFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.butter
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const corner = 28.0;
    final inset = size.shortestSide * 0.12;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );

    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(corner, 0), paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(0, corner), paint);
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(-corner, 0),
      paint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(0, corner),
      paint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(corner, 0),
      paint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(0, -corner),
      paint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(-corner, 0),
      paint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(0, -corner),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
