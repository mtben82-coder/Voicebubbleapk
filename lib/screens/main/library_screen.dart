import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/app_state_provider.dart';
import '../../models/recording_item.dart';
import '../../models/tag.dart';
import '../../widgets/preset_chip.dart';
import '../../widgets/project_card.dart';
import '../../widgets/create_project_dialog.dart';
import '../../widgets/tag_filter_chips.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/tag_management_dialog.dart';
import '../../widgets/multi_option_fab.dart';
import '../../widgets/language_selector_popup.dart';
import '../../constants/presets.dart';
import '../../constants/background_assets.dart';
import '../../constants/languages.dart';
import '../../services/continue_service.dart';
import '../../services/analytics_service.dart';
import '../../services/native_overlay_service.dart';
import '../../services/ai_service.dart';
import '../../services/feature_gate.dart';
import '../templates/template_models.dart';
import '../templates/template_registry.dart';
import '../templates/template_fill_screen.dart';
import '../settings/settings_screen.dart';
import '../paywall/paywall_screen.dart';
import 'project_detail_screen.dart';
import 'recording_detail_screen.dart';
import 'recording_screen.dart';
import '../main/preset_selection_screen.dart';
// ✨ NEW IMPORT ✨
import '../batch_operations_screen.dart';
import '../templates/template_selection_screen.dart';
import '../templates/elite_interview_screen.dart';
import '../templates/elite_interview_system.dart';
// ✨ END NEW IMPORT ✨

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with WidgetsBindingObserver {
  // View modes: 0 = Library, 1 = Projects
  int _viewMode = 0;
  String _searchQuery = '';
  String? _selectedTagId;

  // Template search/filter state
  TemplateCategory? _selectedTemplateCategory;
  String _templateSearchQuery = '';

  // Overlay state (from HomeScreen)
  bool _overlayEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkOverlayStatus();
    _initializeOverlay();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && Platform.isAndroid) {
      debugPrint('📱 App resumed, checking overlay status...');

      final isActive = await NativeOverlayService.isActive();
      final hasPermission = await NativeOverlayService.checkPermission();

      debugPrint('Service active: $isActive, Permission granted: $hasPermission');

      if (hasPermission && !isActive) {
        debugPrint('🚀 Auto-starting service after permission grant...');
        final started = await NativeOverlayService.showOverlay();
        if (started && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Bubble activated! Look on the left side'),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      await _checkOverlayStatus();
    }
  }

  Future<void> _checkOverlayStatus() async {
    if (Platform.isAndroid) {
      final hasPermission = await NativeOverlayService.checkPermission();
      debugPrint('📊 Overlay permission granted: $hasPermission');
      setState(() {
        _overlayEnabled = hasPermission;
      });
    }
  }

  Future<void> _initializeOverlay() async {
    if (Platform.isAndroid) {
      final hasPermission = await NativeOverlayService.checkPermission();
      debugPrint('📊 Initial overlay check - permission granted: $hasPermission');
      setState(() {
        _overlayEnabled = hasPermission;
      });
    }
  }

  Future<void> _toggleOverlay() async {
    if (!Platform.isAndroid) return;

    if (_overlayEnabled) {
      debugPrint('🛑 Stopping overlay service...');
      await NativeOverlayService.hideOverlay();
      setState(() {
        _overlayEnabled = false;
      });
      AnalyticsService().logOverlayActivated(isEnabled: false);
      debugPrint('✅ Overlay service stopped');
    } else {
      debugPrint('🔍 Checking overlay permission...');
      final hasPermission = await NativeOverlayService.checkPermission();
      debugPrint('Permission status: $hasPermission');

      if (!hasPermission) {
        debugPrint('📱 Requesting overlay permission...');

        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Enable Overlay Permission'),
              content: const Text(
                'To use the floating bubble:\n\n'
                '1. Find "VoiceBubble" in the list\n'
                '2. Turn ON "Allow display over other apps"\n'
                '3. Press back to return here\n\n'
                'Tap OK to open settings now.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        await NativeOverlayService.requestPermission();

        await Future.delayed(const Duration(seconds: 1));

        final permissionGranted = await NativeOverlayService.checkPermission();
        debugPrint('Permission granted: $permissionGranted');

        if (permissionGranted && mounted) {
          debugPrint('🚀 Starting overlay service...');
          final started = await NativeOverlayService.showOverlay();
          debugPrint('Service started: $started');

          setState(() {
            _overlayEnabled = started;
          });

          if (started && mounted) {
            AnalyticsService().logOverlayActivated(isEnabled: true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Bubble activated! Close and reopen app to refresh status.'),
                backgroundColor: Color(0xFF10B981),
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        debugPrint('🚀 Starting overlay service (permission already granted)...');
        final started = await NativeOverlayService.showOverlay();
        debugPrint('Service started: $started');

        setState(() {
          _overlayEnabled = started;
        });

        if (started && mounted) {
          AnalyticsService().logOverlayActivated(isEnabled: true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Bubble activated! Close and reopen app to refresh status.'),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(seconds: 4),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Failed to start bubble service'),
              backgroundColor: Color(0xFFEF4444),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav', 'aac', 'ogg', 'flac'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Transcribing audio...'),
                  ],
                ),
              ),
            ),
          ),
        );

        try {
          final aiService = AIService();
          final transcription = await aiService.transcribeAudio(file);

          if (!mounted) return;
          Navigator.pop(context); // Close loading dialog

          if (transcription.isEmpty) {
            throw Exception('No speech detected in audio file');
          }

          final appState = context.read<AppStateProvider>();
          appState.setTranscription(transcription);

          final wordCount = transcription.split(RegExp(r'\s+')).length;
          final estimatedSeconds = (wordCount / 2.5).round().clamp(10, 300);
          await FeatureGate.trackSTTUsage(estimatedSeconds);

          AnalyticsService().logAudioFileUploaded(
            durationSeconds: estimatedSeconds,
            fileType: result.files.single.extension ?? 'unknown',
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PresetSelectionScreen(fromRecording: true),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Transcribed: ${transcription.substring(0, transcription.length > 50 ? 50 : transcription.length)}...'),
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(seconds: 3),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          Navigator.pop(context); // Close loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to transcribe audio: ${e.toString()}'),
              backgroundColor: const Color(0xFFEF4444),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showOptionsMenu(BuildContext context, Color surfaceColor, Color textColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Upload Audio
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.upload_file, color: Color(0xFFF59E0B)),
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFD700),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.workspace_premium, size: 10, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  'Upload Audio',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Pro feature - Transcribe audio files',
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final isPro = await FeatureGate.isPro();

                  if (!isPro) {
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => PaywallScreen(
                          onSubscribe: () => Navigator.pop(context),
                          onRestore: () => Navigator.pop(context),
                          onClose: () => Navigator.pop(context),
                        ),
                      );
                    }
                    return;
                  }

                  final canUse = await FeatureGate.canUseSTT(context);
                  if (!canUse) {
                    return;
                  }

                  _pickAudioFile();
                },
              ),
              Divider(height: 1, color: Colors.white.withOpacity(0.1)),

              // Activate Bubble (Android only)
              if (Platform.isAndroid)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (_overlayEnabled ? const Color(0xFF10B981) : const Color(0xFF3B82F6)).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.bubble_chart,
                      color: _overlayEnabled ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                    ),
                  ),
                  title: Text(
                    _overlayEnabled ? 'Deactivate Voice Bubble' : 'Activate Voice Bubble',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    _overlayEnabled
                        ? 'Bubble is active - Tap to disable'
                        : 'Floating record button',
                    style: TextStyle(
                      color: textColor.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _toggleOverlay();
                    await Future.delayed(const Duration(milliseconds: 500));
                    await _checkOverlayStatus();
                  },
                ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCreateProjectDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);
    final primaryColor = const Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Consumer<AppStateProvider>(
          builder: (context, appState, _) {
            // Get data
            var recordings = appState.recordingItems;
            final projects = appState.projects;

            // Filter recordings
            if (_searchQuery.isNotEmpty) {
              recordings = recordings.where((r) {
                return r.finalText.toLowerCase().contains(_searchQuery) ||
                    r.presetUsed.toLowerCase().contains(_searchQuery);
              }).toList();
            }

            if (_selectedTagId != null && _viewMode == 0) {
              recordings = recordings.where((r) => r.tags.contains(_selectedTagId)).toList();
            }

            // Sort pinned items to the top!
            recordings.sort((a, b) {
              // Pinned items come first
              if (a.isPinned == true && b.isPinned != true) return -1;
              if (a.isPinned != true && b.isPinned == true) return 1;
              // Otherwise sort by date (newest first)
              return b.createdAt.compareTo(a.createdAt);
            });

            return CustomScrollView(
              slivers: [
                // Everything in one scrollable list
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // NEW Header: [All] [Projects] ... [Lang] [Paywall] [Settings]
                      Row(
                        children: [
                          // Left side: All/Projects segmented toggle
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  // All button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _viewMode = 0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _viewMode == 0 ? primaryColor : Colors.transparent,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'All',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _viewMode == 0 ? textColor : secondaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Projects button
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _viewMode = 1),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _viewMode == 1 ? primaryColor : Colors.transparent,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Projects',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _viewMode == 1 ? textColor : secondaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Language button
                          Consumer<AppStateProvider>(
                            builder: (context, appState, _) {
                              final language = appState.selectedLanguage;
                              return GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => const LanguageSelectorPopup(),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        language.flagEmoji,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        language.code.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // Paywall icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => PaywallScreen(
                                    onSubscribe: () {},
                                    onRestore: () {},
                                    onClose: () => Navigator.pop(context),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 18),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Settings icon
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsScreen()),
                              ),
                              icon: Icon(Icons.settings, color: textColor, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Bar + Tag Button (no subtitle)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                                style: TextStyle(color: textColor, fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Search library...',
                                  hintStyle: TextStyle(color: secondaryTextColor),
                                  prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                            ),
                          ),
                          if (_viewMode == 0) ...[
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => const TagManagementDialog(),
                                );
                                if (mounted) {
                                  await appState.refreshTags();
                                  setState(() {}); // Force rebuild
                                }
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _selectedTagId != null ? primaryColor.withOpacity(0.2) : surfaceColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: _selectedTagId != null ? Border.all(color: primaryColor, width: 1) : null,
                                ),
                                child: Icon(
                                  Icons.label,
                                  color: _selectedTagId != null ? primaryColor : secondaryTextColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            // ✨ BATCH OPERATIONS BUTTON ✨
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BatchOperationsScreen(
                                      allNotes: recordings,
                                      onComplete: (_) {
                                        if (mounted) setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: surfaceColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.checklist,
                                  color: secondaryTextColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            // ✨ END BATCH OPERATIONS BUTTON ✨
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Tag Filter Chips (moved up)
                      if (_viewMode == 0)
                        TagFilterChips(
                          selectedTagId: _selectedTagId,
                          onTagSelected: (tagId) => setState(() => _selectedTagId = tagId),
                        ),
                      if (_viewMode == 0) const SizedBox(height: 16),
                      if (_viewMode == 1) const SizedBox(height: 8),

                      // Content based on mode
                      if (_viewMode == 1) ...[
                        // Projects list
                        if (projects.isEmpty)
                          _buildEmptyState('No projects yet', 'Create your first project', secondaryTextColor)
                        else
                          ...projects.map((project) => ProjectCard(
                                project: project,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProjectDetailScreen(projectId: project.id),
                                    ),
                                  );
                                },
                              )),
                      ] else ...[
                        // Library - Recordings grid
                        if (recordings.isEmpty)
                          _buildEmptyState('No recordings yet', 'Your recordings will appear here', secondaryTextColor)
                        else
                          // Grid layout for recordings
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: recordings.length,
                            itemBuilder: (context, index) {
                              return _buildRecordingCard(
                                recordings[index],
                                surfaceColor,
                                textColor,
                                secondaryTextColor,
                              );
                            },
                          ),
                      ],
                      // Add bottom padding so FABs don't cover content
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _viewMode == 1
          ? FloatingActionButton(
              heroTag: 'project_fab',
              // Projects tab - ONLY add project button (simple FAB)
              onPressed: () => _showCreateProjectDialog(context),
              backgroundColor: const Color(0xFF3B82F6),
              child: const Icon(Icons.create_new_folder, color: Colors.white),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // LEFT FAB: Bubble/Upload Audio
                  FloatingActionButton(
                    heroTag: 'bubble_fab',
                    onPressed: () => _showOptionsMenu(context, const Color(0xFF1A1A1A), Colors.white),
                    backgroundColor: const Color(0xFF1A1A1A),
                    mini: true,
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                  // CENTER FAB: Record (BIG)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.large(
                        heroTag: 'record_fab',
                        onPressed: () {
                          Provider.of<AppStateProvider>(context, listen: false).reset();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecordingScreen(),
                            ),
                          );
                        },
                        backgroundColor: const Color(0xFF3B82F6),
                        elevation: 8,
                        child: const Icon(Icons.mic, color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Speak to AI',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                  // RIGHT FAB: MultiOptionFab (without voice option)
                  MultiOptionFab(
                    showProjectOption: false,
                    onVoicePressed: null,
                    onTextPressed: () async {
                      final appState = Provider.of<AppStateProvider>(context, listen: false);
                      final newItem = RecordingItem(
                        id: const Uuid().v4(),
                        rawTranscript: '',
                        finalText: '',
                        presetUsed: 'Text Document',
                        outcomes: [],
                        projectId: null,
                        createdAt: DateTime.now(),
                        editHistory: [],
                        presetId: 'text_document',
                        tags: [],
                        contentType: 'text',
                      );
                      await appState.saveRecording(newItem);

                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordingDetailScreen(recordingId: newItem.id),
                          ),
                        );
                      }
                    },
                    onNotePressed: () async {
                      final appState = Provider.of<AppStateProvider>(context, listen: false);
                      final newItem = RecordingItem(
                        id: const Uuid().v4(),
                        rawTranscript: '',
                        finalText: '',
                        presetUsed: 'Quick Note',
                        outcomes: [],
                        projectId: null,
                        createdAt: DateTime.now(),
                        editHistory: [],
                        presetId: 'quick_note',
                        tags: [],
                        contentType: 'text',
                      );
                      await appState.saveRecording(newItem);

                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordingDetailScreen(recordingId: newItem.id),
                          ),
                        );
                      }
                    },
                    onTodoPressed: () async {
                      final appState = Provider.of<AppStateProvider>(context, listen: false);

                      final newItem = RecordingItem(
                        id: const Uuid().v4(),
                        rawTranscript: '',
                        finalText: '',
                        presetUsed: 'Todo List',
                        outcomes: [],
                        projectId: null,
                        createdAt: DateTime.now(),
                        editHistory: [],
                        presetId: 'todo_list',
                        tags: [],
                        contentType: 'todo',
                      );
                      await appState.saveRecording(newItem);

                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordingDetailScreen(recordingId: newItem.id),
                          ),
                        );
                      }
                    },
                    onImagePressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final ImageSource? source = await showDialog<ImageSource>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1A1A),
                          title: const Text('Add Image', style: TextStyle(color: Colors.white)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo_library, color: Color(0xFF3B82F6)),
                                title: const Text('Gallery', style: TextStyle(color: Colors.white)),
                                onTap: () => Navigator.pop(context, ImageSource.gallery),
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt, color: Color(0xFF3B82F6)),
                                title: const Text('Camera', style: TextStyle(color: Colors.white)),
                                onTap: () => Navigator.pop(context, ImageSource.camera),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (source == null) return;

                      try {
                        final XFile? imageFile = await picker.pickImage(source: source);
                        if (imageFile == null) return;

                        final appDir = await getApplicationDocumentsDirectory();
                        final String fileName = '${const Uuid().v4()}.jpg';
                        final String permanentPath = '${appDir.path}/images/$fileName';

                        await Directory('${appDir.path}/images').create(recursive: true);
                        await File(imageFile.path).copy(permanentPath);

                        final appState = Provider.of<AppStateProvider>(context, listen: false);
                        final newItem = RecordingItem(
                          id: const Uuid().v4(),
                          rawTranscript: permanentPath,
                          finalText: '',
                          presetUsed: 'Image',
                          outcomes: [],
                          projectId: null,
                          createdAt: DateTime.now(),
                          editHistory: [],
                          presetId: 'image',
                          tags: [],
                          contentType: 'image',
                        );

                        await appState.saveRecording(newItem);

                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecordingDetailScreen(recordingId: newItem.id),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error picking image: $e')),
                          );
                        }
                      }
                    },
                    onProjectPressed: () {
                      _showCreateProjectDialog(context);
                    },
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState(String title, String subtitle, Color color) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.library_books_outlined, size: 64, color: color.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 18, color: color)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 14, color: color.withOpacity(0.7))),
        ],
      ),
    );
  }

  Widget _buildRecordingCard(
    RecordingItem item,
    Color surfaceColor,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final contentTypeColor = _getContentTypeColor(item.contentType);
    final contentTypeIcon = _getContentTypeIcon(item.contentType);

    return GestureDetector(
      onTap: () {
        // All content types now use the unified RecordingDetailScreen with RichTextEditor
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecordingDetailScreen(recordingId: item.id)),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              // Show background image if selected
              image: item.background != null && !_isBackgroundPaper(item.background!)
                  ? DecorationImage(
                      image: AssetImage(_getBackgroundAssetPath(item.background!)),
                      fit: BoxFit.cover,
                      opacity: 0.3, // 30% opacity - brighter than before!
                      // NO ColorFilter - let image show naturally
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with content type indicator and date - BOTH LEFT ALIGNED
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Content type indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: contentTypeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            contentTypeIcon,
                            size: 12,
                            color: contentTypeColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.contentType.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: contentTypeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),  // Small gap instead of Spacer
                    // Date/time - now LEFT aligned next to badge
                    Flexible(
                      child: Text(
                        item.formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title (custom title if available, otherwise first line of content)
                Text(
                  item.customTitle?.isNotEmpty == true
                      ? item.customTitle!
                      : item.finalText.split('\n').first,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Preview text (show content, but skip first line if we used it as title and no custom title)
                Text(
                  item.customTitle?.isNotEmpty == true
                      ? item.finalText
                      : _getPreviewText(item.finalText),
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Tags at bottom as colored text
                Consumer<AppStateProvider>(
                  builder: (context, appState, _) {
                    final tags = appState.tags;
                    final itemTags = item.tags
                        .map((tagId) => tags.where((t) => t.id == tagId).firstOrNull)
                        .where((t) => t != null)
                        .cast<Tag>()
                        .toList();

                    if (itemTags.isEmpty) return const SizedBox(height: 8);

                    return Text(
                      itemTags.map((tag) => tag.name).join(', '),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(itemTags.first.color),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          // Pin indicator at BOTTOM RIGHT (if pinned)
          if (item.isPinned == true)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.push_pin,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getPreviewText(String fullText) {
    final lines = fullText.split('\n');
    if (lines.length <= 1) {
      return ''; // No preview if only one line
    }
    return lines.skip(1).join('\n');
  }

  IconData _getContentTypeIcon(String contentType) {
    switch (contentType) {
      case 'text':
        return Icons.text_fields;
      case 'image':
        return Icons.image;
      case 'todo':
        return Icons.checklist;
      case 'voice':
      default:
        return Icons.mic;
    }
  }

  bool _isBackgroundPaper(String backgroundId) {
    // Paper backgrounds start with 'paper_'
    return backgroundId.startsWith('paper_');
  }

  String _getBackgroundAssetPath(String backgroundId) {
    // Use BackgroundAssets registry to get correct path
    final background = BackgroundAssets.findById(backgroundId);
    return background?.assetPath ?? 'assets/backgrounds/abstract_waves.jpg';
  }

  Color _getContentTypeColor(String contentType) {
    switch (contentType) {
      case 'text':
        return const Color(0xFFF59E0B);
      case 'image':
        return const Color(0xFF10B981);
      case 'todo':
        return const Color(0xFF8B5CF6);
      case 'voice':
      default:
        return const Color(0xFFEF4444);
    }
  }

  // Build templates view (embedded template selection)
  Widget _buildTemplatesView(Color surfaceColor, Color textColor, Color secondaryTextColor) {
    // Get all templates (no filtering)
    final filteredTemplates = allTemplates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Removed category pills - just show templates

        // Templates grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredTemplates.length,
          itemBuilder: (context, index) {
            final template = filteredTemplates[index];
            return _buildTemplateCard(template, surfaceColor, textColor, secondaryTextColor);
          },
        ),
      ],
    );
  }

  Widget _buildTemplateCategoryPill(TemplateCategory? category, String label, IconData icon,
      Color surfaceColor, Color textColor, Color secondaryTextColor) {
    final isSelected = _selectedTemplateCategory == category;
    final color = category?.color ?? const Color(0xFF8B5CF6);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedTemplateCategory = category),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? color : secondaryTextColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedTemplateCard(AppTemplate template, Color surfaceColor, Color textColor, Color secondaryTextColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TemplateFillScreen(template: template)),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [template.category.color.withOpacity(0.2), template.category.color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: template.category.color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: template.category.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(template.category.icon, color: template.category.color, size: 20),
                ),
                const Spacer(),
                if (template.isPro)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('PRO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  template.description,
                  style: TextStyle(fontSize: 11, color: secondaryTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(AppTemplate template, Color surfaceColor, Color textColor, Color secondaryTextColor) {
    // Use consistent color for all cards
    const cardColor = Color(0xFF3B82F6); // Blue for all templates

    return GestureDetector(
      onTap: () {
        // Launch EliteInterviewScreen if template has interview flow
        if (template.interviewFlow != null && template.interviewFlow!.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EliteInterviewScreen(
                template: template,
                questions: template.interviewFlow!.cast<InterviewQuestion>(),
                onComplete: (answers) async {
                  // Pop back to library
                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${template.name} created successfully!'),
                      backgroundColor: const Color(0xFF10B981),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Refresh the library to show new item
                  setState(() {});
                },
              ),
            ),
          );
        } else {
          // Fallback to old fill screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TemplateFillScreen(template: template)),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(template.icon, color: cardColor, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              template.name,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              template.tagline,
              style: TextStyle(fontSize: 11, color: secondaryTextColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.mic, size: 12, color: cardColor),
                const SizedBox(width: 4),
                Text(
                  '${template.interviewFlow?.length ?? 0} questions',
                  style: TextStyle(fontSize: 10, color: cardColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
