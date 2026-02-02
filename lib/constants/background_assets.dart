import 'package:flutter/material.dart';

/// Represents a background asset (paper or image)
class BackgroundAsset {
  final String id;
  final String name;
  final String? assetPath;
  final bool isPaper;
  final Color? fallbackColor;

  const BackgroundAsset({
    required this.id,
    required this.name,
    this.assetPath,
    this.isPaper = false,
    this.fallbackColor,
  });
}

/// Central registry of all background assets
class BackgroundAssets {
  BackgroundAssets._();

  // ════════════════════════════════════════════════════════════════════════════
  // PAPER TYPES (PDF-based)
  // ════════════════════════════════════════════════════════════════════════════

  static const List<BackgroundAsset> allPapers = [
    BackgroundAsset(
      id: 'paper_grid',
      name: 'Grid Paper',
      assetPath: 'assets/backgrounds/grid_paper.pdf',
      isPaper: true,
      fallbackColor: Color(0xFFF5F5F5),
    ),
    BackgroundAsset(
      id: 'paper_dotted',
      name: 'Dotted Paper',
      assetPath: 'assets/backgrounds/dotted_paper.pdf',
      isPaper: true,
      fallbackColor: Color(0xFFF5F5F5),
    ),
    BackgroundAsset(
      id: 'paper_minimal_dot',
      name: 'Minimal Dot Notes',
      assetPath: 'assets/backgrounds/Minimal Dot Notes Sheet_20260201_233526_0000.pdf',
      isPaper: true,
      fallbackColor: Color(0xFFFAFAFA),
    ),
    BackgroundAsset(
      id: 'paper_minimalist',
      name: 'Minimalist Paper',
      assetPath: 'assets/backgrounds/Minimalist Paper Notes_20260201_233623_0000.pdf',
      isPaper: true,
      fallbackColor: Color(0xFFFEFEFE),
    ),
    BackgroundAsset(
      id: 'paper_grey_notebook',
      name: 'Grey Notebook',
      assetPath: 'assets/backgrounds/Grey White Minimal Note Book Papers Planner_20260201_233338_0000.pdf',
      isPaper: true,
      fallbackColor: Color(0xFFE8E8E8),
    ),
    BackgroundAsset(
      id: 'paper_vintage',
      name: 'Vintage Scrapbook',
      assetPath: 'assets/backgrounds/Beige Brown Simple Vintage Scrapbook Paper Page Border A4 Document_20260201_233753_0000.pdf',
      isPaper: true,
      fallbackColor: Color(0xFFF5E6D3),
    ),
  ];

  // ════════════════════════════════════════════════════════════════════════════
  // IMAGE BACKGROUNDS
  // ════════════════════════════════════════════════════════════════════════════

  static const List<BackgroundAsset> allBackgrounds = [
    BackgroundAsset(
      id: 'bg_abstract_waves',
      name: 'Abstract Waves',
      assetPath: 'assets/backgrounds/abstract_waves.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF1E3A5F),
    ),
    BackgroundAsset(
      id: 'bg_beach_aerial',
      name: 'Beach Aerial',
      assetPath: 'assets/backgrounds/beach_aerial.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF2196F3),
    ),
    BackgroundAsset(
      id: 'bg_desert_dunes',
      name: 'Desert Dunes',
      assetPath: 'assets/backgrounds/desert_dunes.jpg',
      isPaper: false,
      fallbackColor: Color(0xFFD4A574),
    ),
    BackgroundAsset(
      id: 'bg_forest_path',
      name: 'Forest Path',
      assetPath: 'assets/backgrounds/forest_path.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF2D5016),
    ),
    BackgroundAsset(
      id: 'bg_galaxy_stars',
      name: 'Galaxy Stars',
      assetPath: 'assets/backgrounds/galaxy_stars.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF1A1A2E),
    ),
    BackgroundAsset(
      id: 'bg_galaxy_panorama',
      name: 'Galaxy Panorama',
      assetPath: 'assets/backgrounds/galaxy-night-panorama.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF0D1B2A),
    ),
    BackgroundAsset(
      id: 'bg_beach_sunny',
      name: 'Sunny Beach',
      assetPath: 'assets/backgrounds/aerial-shot-people-enjoying-beach-sunny-day.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF4FC3F7),
    ),
    BackgroundAsset(
      id: 'bg_sea_rocks',
      name: 'Sea & Rocks',
      assetPath: 'assets/backgrounds/vertical-aerial-shot-sea-waves-hitting-rocks-shore.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF0077B6),
    ),
    BackgroundAsset(
      id: 'bg_2083',
      name: 'Gradient Blue',
      assetPath: 'assets/backgrounds/2083.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF3F51B5),
    ),
    BackgroundAsset(
      id: 'bg_3371',
      name: 'Gradient Purple',
      assetPath: 'assets/backgrounds/3371.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF7B1FA2),
    ),
    BackgroundAsset(
      id: 'bg_9559',
      name: 'Gradient Pink',
      assetPath: 'assets/backgrounds/9559.jpg',
      isPaper: false,
      fallbackColor: Color(0xFFE91E63),
    ),
    BackgroundAsset(
      id: 'bg_9580989',
      name: 'Gradient Teal',
      assetPath: 'assets/backgrounds/9580989_37119.jpg',
      isPaper: false,
      fallbackColor: Color(0xFF009688),
    ),
  ];

  // ════════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ════════════════════════════════════════════════════════════════════════════

  /// Get all available backgrounds (papers + images)
  static List<BackgroundAsset> get all => [...allPapers, ...allBackgrounds];

  /// Find a background by its ID, returns null if not found
  static BackgroundAsset? findById(String id) {
    try {
      return all.firstWhere((bg) => bg.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Check if a background ID exists
  static bool exists(String id) => findById(id) != null;
}
