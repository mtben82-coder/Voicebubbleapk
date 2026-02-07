import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// ═══════════════════════════════════════════════════════════════════════════
/// VOICEBUBBLE CINEMA - THE EXPERIENCE
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Slower. Cleaner. Each moment breathes.
/// Text appears smoothly, centered, readable.
/// No rushing. No clutter. Just impact.
///
/// ═══════════════════════════════════════════════════════════════════════════

class FeatureShowcaseScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const FeatureShowcaseScreen({super.key, required this.onComplete});

  @override
  State<FeatureShowcaseScreen> createState() => _FeatureShowcaseScreenState();
}

class _FeatureShowcaseScreenState extends State<FeatureShowcaseScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _sceneController;
  late AnimationController _loopController;
  
  int _currentScene = 0;
  bool _isFinale = false;
  
  // 8 scenes + finale
  static const int _totalScenes = 8;
  // Each scene: 3.5 seconds (slower, more time to absorb)
  static const Duration _sceneDuration = Duration(milliseconds: 3500);
  // Pause between scenes
  static const Duration _scenePause = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    
    _sceneController = AnimationController(
      duration: _sceneDuration,
      vsync: this,
    );
    
    _loopController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    
    _startCinema();
  }

  Future<void> _startCinema() async {
    for (int i = 0; i < _totalScenes; i++) {
      if (!mounted) return;
      
      setState(() => _currentScene = i);
      await _sceneController.forward(from: 0);
      
      if (!mounted) return;
      await Future.delayed(_scenePause);
    }
    
    // Show finale
    if (mounted) {
      setState(() => _isFinale = true);
    }
  }

  void _skip() {
    HapticFeedback.mediumImpact();
    widget.onComplete();
  }

  @override
  void dispose() {
    _sceneController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // Main content
          _isFinale
              ? _Finale(
                  loopController: _loopController,
                  onComplete: widget.onComplete,
                )
              : _buildCurrentScene(),
          
          // Skip button - top right, subtle
          if (!_isFinale)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: GestureDetector(
                onTap: _skip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentScene() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(_currentScene),
        child: _getScene(_currentScene),
      ),
    );
  }

  Widget _getScene(int index) {
    switch (index) {
      case 0:
        return _SceneVoice(controller: _sceneController, loopController: _loopController);
      case 1:
        return _ScenePresets(controller: _sceneController, loopController: _loopController);
      case 2:
        return _SceneHighlight(controller: _sceneController);
      case 3:
        return _SceneImport(controller: _sceneController, loopController: _loopController);
      case 4:
        return _SceneOCR(controller: _sceneController);
      case 5:
        return _SceneTasks(controller: _sceneController);
      case 6:
        return _SceneBatch(controller: _sceneController);
      case 7:
        return _SceneAnywhere(controller: _sceneController, loopController: _loopController);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 1: VOICE - Waveform + "Speak. AI Writes. Done."
// ═══════════════════════════════════════════════════════════════════════════

class _SceneVoice extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _SceneVoice({required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        // Smooth fade in for first 20% of animation
        final fadeIn = (controller.value * 5).clamp(0.0, 1.0);
        // Fade out in last 15%
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Waveform
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(7, (i) {
                        final wave = math.sin((loopController.value * math.pi * 2) + (i * 0.7));
                        final height = 20 + (wave.abs() * 45);
                        
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 6,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Text - simple, centered, clean
                  _AnimatedText(
                    text: 'Speak.',
                    controller: controller,
                    delay: 0.1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      height: 1.2,
                    ),
                  ),
                  _AnimatedText(
                    text: 'AI Writes.',
                    controller: controller,
                    delay: 0.2,
                    gradient: const [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      height: 1.2,
                    ),
                  ),
                  _AnimatedText(
                    text: 'Done.',
                    controller: controller,
                    delay: 0.3,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 2: PRESETS - Chips + "20+ Presets. One Tap."
// ═══════════════════════════════════════════════════════════════════════════

class _ScenePresets extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _ScenePresets({required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    final presets = [
      ('Magic', const Color(0xFF9333EA)),
      ('Email', const Color(0xFFDC2626)),
      ('Social', const Color(0xFFEC4899)),
      ('Poem', const Color(0xFFF59E0B)),
      ('Notes', const Color(0xFF10B981)),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final fadeIn = (controller.value * 4).clamp(0.0, 1.0);
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        // Active preset cycles every 0.5 seconds
        final activeIndex = ((loopController.value * presets.length * 2).floor()) % presets.length;

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Preset chips
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(presets.length, (i) {
                      final isActive = i == activeIndex && controller.value > 0.3;
                      final preset = presets[i];
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: isActive ? preset.$2 : preset.$2.withOpacity(0.2),
                          border: Border.all(
                            color: preset.$2.withOpacity(isActive ? 0.8 : 0.4),
                            width: 2,
                          ),
                          boxShadow: isActive ? [
                            BoxShadow(
                              color: preset.$2.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ] : null,
                        ),
                        child: Text(
                          preset.$1,
                          style: TextStyle(
                            color: Colors.white.withOpacity(isActive ? 1 : 0.7),
                            fontSize: 16,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Text
                  _AnimatedText(
                    text: '20+ Presets.',
                    controller: controller,
                    delay: 0.15,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _AnimatedText(
                    text: 'One Tap.',
                    controller: controller,
                    delay: 0.25,
                    gradient: const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 3: HIGHLIGHT - "Highlight. Transform."
// ═══════════════════════════════════════════════════════════════════════════

class _SceneHighlight extends StatelessWidget {
  final AnimationController controller;

  const _SceneHighlight({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final fadeIn = (controller.value * 4).clamp(0.0, 1.0);
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        // Highlight sweep from 20% to 50%
        final highlightProgress = ((controller.value - 0.2) / 0.3).clamp(0.0, 1.0);
        // Transform appears from 55% to 75%
        final transformProgress = ((controller.value - 0.55) / 0.2).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Original text with highlight
                  ClipRect(
                    child: Stack(
                      children: [
                        // Base text (faded)
                        Text(
                          'make this better',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Highlighted portion
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.transparent,
                                Colors.transparent,
                              ],
                              stops: [0, highlightProgress, highlightProgress, 1],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcIn,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'make this better',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Arrow
                  Opacity(
                    opacity: transformProgress,
                    child: const Icon(
                      Icons.arrow_downward_rounded,
                      color: Color(0xFFF59E0B),
                      size: 28,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Transformed text
                  Opacity(
                    opacity: transformProgress,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - transformProgress)),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                        ).createShader(bounds),
                        child: const Text(
                          'elevated to perfection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Label
                  _AnimatedText(
                    text: 'Highlight. Transform.',
                    controller: controller,
                    delay: 0.1,
                    gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 4: IMPORT - File icons + "Import. Export. Anything."
// ═══════════════════════════════════════════════════════════════════════════

class _SceneImport extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _SceneImport({required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    final files = [
      (Icons.picture_as_pdf_rounded, const Color(0xFFEF4444)),
      (Icons.description_rounded, const Color(0xFF3B82F6)),
      (Icons.image_rounded, const Color(0xFF10B981)),
      (Icons.audiotrack_rounded, const Color(0xFF8B5CF6)),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final fadeIn = (controller.value * 4).clamp(0.0, 1.0);
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // File icons floating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(files.length, (i) {
                    final float = math.sin((loopController.value * math.pi * 2) + (i * 1.5)) * 8;
                    final file = files[i];
                    
                    return Transform.translate(
                      offset: Offset(0, float),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: file.$2,
                          boxShadow: [
                            BoxShadow(
                              color: file.$2.withOpacity(0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(file.$1, color: Colors.white, size: 28),
                      ),
                    );
                  }),
                ),
                
                const SizedBox(height: 50),
                
                // Text
                _AnimatedText(
                  text: 'Import. Export.',
                  controller: controller,
                  delay: 0.15,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                _AnimatedText(
                  text: 'Anything.',
                  controller: controller,
                  delay: 0.25,
                  gradient: const [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 5: OCR - Image scan + "Image to Text. Instant."
// ═══════════════════════════════════════════════════════════════════════════

class _SceneOCR extends StatelessWidget {
  final AnimationController controller;

  const _SceneOCR({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final fadeIn = (controller.value * 4).clamp(0.0, 1.0);
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        // Scan line moves from 20% to 60%
        final scanProgress = ((controller.value - 0.2) / 0.4).clamp(0.0, 1.0);
        // Text appears from 55%
        final textReveal = ((controller.value - 0.55) / 0.2).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image frame with scan
                Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Document lines
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _docLine(0.8),
                            const SizedBox(height: 8),
                            _docLine(0.6),
                            const SizedBox(height: 8),
                            _docLine(0.7),
                          ],
                        ),
                      ),
                      // Scan line
                      if (scanProgress > 0 && scanProgress < 1)
                        Positioned(
                          top: scanProgress * 120,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF10B981),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.8),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Extracted text
                Opacity(
                  opacity: textReveal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF10B981).withOpacity(0.15),
                    ),
                    child: const Text(
                      '"Meeting tomorrow at 3pm..."',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Label
                _AnimatedText(
                  text: 'Image to Text.',
                  controller: controller,
                  delay: 0.1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                _AnimatedText(
                  text: 'Instant.',
                  controller: controller,
                  delay: 0.2,
                  gradient: const [Color(0xFF10B981), Color(0xFF06B6D4)],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _docLine(double width) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 6: TASKS - "Voice to Tasks."
// ═══════════════════════════════════════════════════════════════════════════

class _SceneTasks extends StatelessWidget {
  final AnimationController controller;

  const _SceneTasks({required this.controller});

  @override
  Widget build(BuildContext context) {
    final tasks = ['Call Sarah', 'Send report', 'Book flight'];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final fadeIn = (controller.value * 4).clamp(0.0, 1.0);
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tasks
                ...List.generate(tasks.length, (i) {
                  final taskProgress = ((controller.value - 0.15 - (i * 0.1)) / 0.2).clamp(0.0, 1.0);
                  
                  return Opacity(
                    opacity: taskProgress,
                    child: Transform.translate(
                      offset: Offset(-20 * (1 - taskProgress), 0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.08),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                                ),
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              tasks[i],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                const SizedBox(height: 40),
                
                // Label
                _AnimatedText(
                  text: 'Voice to Tasks.',
                  controller: controller,
                  delay: 0.1,
                  gradient: const [Color(0xFF10B981), Color(0xFF06B6D4)],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 7: BATCH - "Process in Batches."
// ═══════════════════════════════════════════════════════════════════════════

class _SceneBatch extends StatelessWidget {
  final AnimationController controller;

  const _SceneBatch({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final fadeIn = (controller.value * 4).clamp(0.0, 1.0);
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        // Docs merge from 20% to 60%
        final mergeProgress = ((controller.value - 0.2) / 0.4).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Multiple docs merging
                SizedBox(
                  width: 200,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(5, (i) {
                      final startOffset = (i - 2) * 30.0;
                      final currentOffset = startOffset * (1 - mergeProgress);
                      
                      return Transform.translate(
                        offset: Offset(currentOffset, 0),
                        child: Container(
                          width: 45,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366F1).withOpacity(0.9 - (i * 0.15)),
                                const Color(0xFF8B5CF6).withOpacity(0.7 - (i * 0.1)),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.description, color: Colors.white70, size: 22),
                        ),
                      );
                    }),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Counter
                Text(
                  '${(mergeProgress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Label
                _AnimatedText(
                  text: 'Process in Batches.',
                  controller: controller,
                  delay: 0.1,
                  gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 8: ANYWHERE - Floating bubble + "Anywhere."
// ═══════════════════════════════════════════════════════════════════════════

class _SceneAnywhere extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _SceneAnywhere({required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final fadeIn = (controller.value * 4).clamp(0.0, 1.0);
        final fadeOut = controller.value > 0.85 
            ? ((controller.value - 0.85) / 0.15).clamp(0.0, 1.0) 
            : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        final float = math.sin(loopController.value * math.pi * 2) * 10;

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Floating bubble
                Transform.translate(
                  offset: Offset(0, float),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.mic_rounded, color: Colors.white, size: 44),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Label
                _AnimatedText(
                  text: 'Anywhere.',
                  controller: controller,
                  delay: 0.15,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FINALE - Logo + "100x Your Voice" + Get Started
// ═══════════════════════════════════════════════════════════════════════════

class _Finale extends StatefulWidget {
  final AnimationController loopController;
  final VoidCallback onComplete;

  const _Finale({required this.loopController, required this.onComplete});

  @override
  State<_Finale> createState() => _FinaleState();
}

class _FinaleState extends State<_Finale> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeController, widget.loopController]),
      builder: (context, _) {
        final appear = Curves.easeOut.transform(_fadeController.value);
        final glow = 0.4 + (math.sin(widget.loopController.value * math.pi * 2) * 0.2);

        return Opacity(
          opacity: appear,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Transform.scale(
                    scale: 0.9 + (appear * 0.1),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(glow),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/app_logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              ),
                            ),
                            child: const Icon(Icons.mic, color: Colors.white, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Tagline
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    ).createShader(bounds),
                    child: const Text(
                      '100x',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  const Text(
                    'Your Voice. Your Docs.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Get Started button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      widget.onComplete();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER: Animated Text with optional gradient
// ═══════════════════════════════════════════════════════════════════════════

class _AnimatedText extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final double delay;
  final TextStyle style;
  final List<Color>? gradient;

  const _AnimatedText({
    required this.text,
    required this.controller,
    required this.delay,
    required this.style,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = ((controller.value - delay) / 0.2).clamp(0.0, 1.0);
        final opacity = Curves.easeOut.transform(progress);
        final offset = 15 * (1 - progress);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, offset),
            child: gradient != null
                ? ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(colors: gradient!).createShader(bounds),
                    child: Text(text, style: style, textAlign: TextAlign.center),
                  )
                : Text(text, style: style, textAlign: TextAlign.center),
          ),
        );
      },
    );
  }
}
