import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// ═══════════════════════════════════════════════════════════════════════════
/// VOICEBUBBLE CINEMA - THE SICK 7-SCENE FLOW
/// 
/// Frame 1: The Unified Library
/// Frame 2: Capture Everything  
/// Frame 3: Share & Process
/// Frame 4: One-Tap Magic
/// Frame 5: Refine & Perfect
/// Frame 6: Highlight & Transform
/// Frame 7: The Outcome (The Magic Pull)
/// FINALE: Power at your fingertips.
/// ═══════════════════════════════════════════════════════════════════════════

class FeatureShowcaseScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FeatureShowcaseScreen({super.key, required this.onComplete});
  @override
  State<FeatureShowcaseScreen> createState() => _FeatureShowcaseScreenState();
}

class _FeatureShowcaseScreenState extends State<FeatureShowcaseScreen> with TickerProviderStateMixin {
  late AnimationController _sceneController;
  late AnimationController _loopController;
  late AnimationController _pulseController;
  
  int _currentScene = 0;
  bool _isFinale = false;
  
  static const int _totalScenes = 7;
  static const Duration _sceneDuration = Duration(milliseconds: 3800);
  static const Duration _scenePause = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _sceneController = AnimationController(duration: _sceneDuration, vsync: this);
    _loopController = AnimationController(duration: const Duration(milliseconds: 2500), vsync: this)..repeat();
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1800), vsync: this)..repeat(reverse: true);
    _startCinema();
  }

  Future<void> _startCinema() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Initial pause
    for (int i = 0; i < _totalScenes; i++) {
      if (!mounted) return;
      setState(() => _currentScene = i);
      await _sceneController.forward(from: 0);
      if (!mounted) return;
      await Future.delayed(_scenePause);
    }
    if (mounted) setState(() => _isFinale = true);
  }

  void _skip() { 
    HapticFeedback.mediumImpact(); 
    widget.onComplete(); 
  }

  @override
  void dispose() { 
    _sceneController.dispose(); 
    _loopController.dispose(); 
    _pulseController.dispose();
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // Ambient glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final glow = 0.04 + (_pulseController.value * 0.03);
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.3),
                    radius: 1.2,
                    colors: [
                      const Color(0xFF8B5CF6).withOpacity(glow),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Main content
          _isFinale 
            ? _Finale(loopController: _loopController, pulseController: _pulseController, onComplete: widget.onComplete) 
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey(_currentScene), 
                  child: _getScene(_currentScene),
                ),
              ),
          
          // Skip button
          if (!_isFinale) 
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: GestureDetector(
                onTap: _skip, 
                child: Text(
                  'Skip', 
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.25), 
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getScene(int index) {
    switch (index) {
      case 0: return _Scene1Library(controller: _sceneController, pulseController: _pulseController);
      case 1: return _Scene2Capture(controller: _sceneController, loopController: _loopController);
      case 2: return _Scene3Share(controller: _sceneController);
      case 3: return _Scene4Presets(controller: _sceneController, loopController: _loopController);
      case 4: return _Scene5Refine(controller: _sceneController);
      case 5: return _Scene6Highlight(controller: _sceneController);
      case 6: return _Scene7Outcome(controller: _sceneController, loopController: _loopController);
      default: return const SizedBox.shrink();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FRAME 1: THE UNIFIED LIBRARY
// "A single home for your notes, imports, and batch projects."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene1Library extends StatelessWidget {
  final AnimationController controller;
  final AnimationController pulseController;
  const _Scene1Library({required this.controller, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    final folders = [
      (Icons.note_rounded, 'Notes', const Color(0xFF3B82F6)),
      (Icons.file_download_rounded, 'Imports', const Color(0xFF8B5CF6)),
      (Icons.folder_rounded, 'Projects', const Color(0xFF10B981)),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([controller, pulseController]),
      builder: (context, _) {
        final fadeIn = Curves.easeOut.transform((controller.value / 0.15).clamp(0.0, 1.0));
        final fadeOut = controller.value > 0.85 ? Curves.easeIn.transform(((controller.value - 0.85) / 0.15).clamp(0.0, 1.0)) : 0.0;
        final opacity = fadeIn * (1 - fadeOut);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Folder icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(folders.length, (i) {
                      final delay = i * 0.08;
                      final itemAppear = Curves.easeOut.transform(((controller.value - delay) / 0.2).clamp(0.0, 1.0));
                      final folder = folders[i];
                      final float = math.sin((pulseController.value * math.pi) + (i * 0.8)) * 4;
                      
                      return Opacity(
                        opacity: itemAppear,
                        child: Transform.translate(
                          offset: Offset(0, (12 * (1 - itemAppear)) + float),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: folder.$3.withOpacity(0.15),
                                    border: Border.all(color: folder.$3.withOpacity(0.3), width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: folder.$3.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(folder.$1, color: folder.$3, size: 32),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  folder.$2,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Text
                  _AnimatedHeadline(
                    controller: controller,
                    delay: 0.2,
                    text: 'The Unified Library',
                  ),
                  const SizedBox(height: 14),
                  _AnimatedSubhead(
                    controller: controller,
                    delay: 0.28,
                    text: 'A single home for your notes,\nimports, and batch projects.',
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
// FRAME 2: CAPTURE EVERYTHING
// "See it. Speak it. Snap it. Capture ideas at the speed of thought."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene2Capture extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;
  const _Scene2Capture({required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final fadeIn = Curves.easeOut.transform((controller.value / 0.15).clamp(0.0, 1.0));
        final fadeOut = controller.value > 0.85 ? Curves.easeIn.transform(((controller.value - 0.85) / 0.15).clamp(0.0, 1.0)) : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        final scanProgress = ((controller.value - 0.25) / 0.35).clamp(0.0, 1.0);
        final extractAppear = Curves.easeOut.transform(((controller.value - 0.6) / 0.15).clamp(0.0, 1.0));

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Camera frame with scan
                  Container(
                    width: 180,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF10B981).withOpacity(0.5), width: 2),
                      color: Colors.white.withOpacity(0.03),
                    ),
                    child: Stack(
                      children: [
                        // Document lines
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _DocLine(width: 0.9),
                              _DocLine(width: 0.6),
                              _DocLine(width: 0.75),
                              _DocLine(width: 0.5),
                            ],
                          ),
                        ),
                        // Scan line
                        if (scanProgress > 0 && scanProgress < 1)
                          Positioned(
                            top: scanProgress * 130,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, const Color(0xFF10B981), Colors.transparent],
                                ),
                                boxShadow: [
                                  BoxShadow(color: const Color(0xFF10B981).withOpacity(0.8), blurRadius: 12, spreadRadius: 2),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Extracted badge
                  Opacity(
                    opacity: extractAppear,
                    child: Transform.translate(
                      offset: Offset(0, 8 * (1 - extractAppear)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF10B981).withOpacity(0.15),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                            const SizedBox(width: 6),
                            Text('Text extracted', style: TextStyle(color: const Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  _AnimatedHeadline(
                    controller: controller,
                    delay: 0.15,
                    text: 'Capture Everything',
                  ),
                  const SizedBox(height: 14),
                  _AnimatedSubhead(
                    controller: controller,
                    delay: 0.22,
                    text: 'See it. Speak it. Snap it.\nCapture ideas at the speed of thought.',
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
// FRAME 3: SHARE & PROCESS
// "Share from any app and process with AI instantly."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene3Share extends StatelessWidget {
  final AnimationController controller;
  const _Scene3Share({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final fadeIn = Curves.easeOut.transform((controller.value / 0.15).clamp(0.0, 1.0));
        final fadeOut = controller.value > 0.85 ? Curves.easeIn.transform(((controller.value - 0.85) / 0.15).clamp(0.0, 1.0)) : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        // PDF flies in
        final flyIn = Curves.easeOutCubic.transform((controller.value / 0.35).clamp(0.0, 1.0));
        // Processing
        final processing = ((controller.value - 0.35) / 0.25).clamp(0.0, 1.0);
        // Complete
        final complete = Curves.easeOut.transform(((controller.value - 0.6) / 0.12).clamp(0.0, 1.0));

        final pdfX = 160.0 * (1 - flyIn);
        final pdfY = -220.0 * (1 - flyIn);

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animation area
                  SizedBox(
                    width: 200,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Target zone
                        Container(
                          width: 130,
                          height: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.04),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6).withOpacity(flyIn * 0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: complete > 0
                                ? Opacity(
                                    opacity: complete,
                                    child: Transform.scale(
                                      scale: 0.8 + (complete * 0.2),
                                      child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 44),
                                    ),
                                  )
                                : processing > 0
                                    ? SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                          value: processing,
                                          strokeWidth: 3,
                                          color: const Color(0xFF8B5CF6),
                                          backgroundColor: Colors.white.withOpacity(0.1),
                                        ),
                                      )
                                    : Icon(Icons.add_rounded, color: Colors.white.withOpacity(0.15), size: 32),
                          ),
                        ),
                        
                        // Flying PDF
                        if (flyIn < 1)
                          Transform.translate(
                            offset: Offset(pdfX, pdfY),
                            child: Transform.rotate(
                              angle: (1 - flyIn) * 0.35,
                              child: Container(
                                width: 58,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFEF4444),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEF4444).withOpacity(0.5),
                                      blurRadius: 18,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 28),
                                    const SizedBox(height: 2),
                                    Text('PDF', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  _AnimatedHeadline(
                    controller: controller,
                    delay: 0.25,
                    text: 'Share & Process',
                  ),
                  const SizedBox(height: 14),
                  _AnimatedSubhead(
                    controller: controller,
                    delay: 0.32,
                    text: 'Share PDFs or docs from any app\nand process with AI instantly.',
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
// FRAME 4: ONE-TAP MAGIC
// "Apply 20+ AI presets to instantly draft emails, threads, or social posts."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene4Presets extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;
  const _Scene4Presets({required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    final presets = [
      ('Email', const Color(0xFFDC2626)),
      ('Thread', const Color(0xFF3B82F6)),
      ('Social', const Color(0xFFEC4899)),
      ('Notes', const Color(0xFF10B981)),
      ('Poem', const Color(0xFFF59E0B)),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final fadeIn = Curves.easeOut.transform((controller.value / 0.15).clamp(0.0, 1.0));
        final fadeOut = controller.value > 0.85 ? Curves.easeIn.transform(((controller.value - 0.85) / 0.15).clamp(0.0, 1.0)) : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        final activeIndex = controller.value > 0.25 
            ? ((loopController.value * presets.length * 1.5).floor()) % presets.length
            : -1;

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Preset chips
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(presets.length, (i) {
                      final delay = 0.1 + (i * 0.05);
                      final chipAppear = Curves.easeOut.transform(((controller.value - delay) / 0.15).clamp(0.0, 1.0));
                      final isActive = i == activeIndex;
                      final preset = presets[i];
                      
                      return Opacity(
                        opacity: chipAppear,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - chipAppear)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: isActive ? preset.$2 : preset.$2.withOpacity(0.12),
                              border: Border.all(
                                color: preset.$2.withOpacity(isActive ? 0.8 : 0.3),
                                width: 1.5,
                              ),
                              boxShadow: isActive ? [
                                BoxShadow(color: preset.$2.withOpacity(0.4), blurRadius: 16),
                              ] : null,
                            ),
                            child: Text(
                              preset.$1,
                              style: TextStyle(
                                color: Colors.white.withOpacity(isActive ? 1 : 0.7),
                                fontSize: 15,
                                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 55),
                  
                  _AnimatedHeadline(
                    controller: controller,
                    delay: 0.3,
                    text: 'One-Tap Magic',
                  ),
                  const SizedBox(height: 14),
                  _AnimatedSubhead(
                    controller: controller,
                    delay: 0.38,
                    text: 'Apply 20+ AI presets to instantly\ndraft emails, threads, or social posts.',
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
// FRAME 5: REFINE & PERFECT
// "Not quite right? Just tell the AI what to change until it's perfect."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene5Refine extends StatelessWidget {
  final AnimationController controller;
  const _Scene5Refine({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final fadeIn = Curves.easeOut.transform((controller.value / 0.15).clamp(0.0, 1.0));
        final fadeOut = controller.value > 0.85 ? Curves.easeIn.transform(((controller.value - 0.85) / 0.15).clamp(0.0, 1.0)) : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        final boxAppear = Curves.easeOut.transform(((controller.value - 0.1) / 0.15).clamp(0.0, 1.0));
        final typing = ((controller.value - 0.25) / 0.3).clamp(0.0, 1.0);
        final sparkle = Curves.easeOut.transform(((controller.value - 0.55) / 0.12).clamp(0.0, 1.0));

        const instruction = 'Make it more professional';
        final visibleChars = (instruction.length * typing).floor();

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Input box
                  Opacity(
                    opacity: boxAppear,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - boxAppear)),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white.withOpacity(0.04),
                          border: Border.all(
                            color: sparkle > 0 
                                ? Color.lerp(Colors.white.withOpacity(0.1), const Color(0xFFF59E0B), sparkle)!
                                : Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                          boxShadow: sparkle > 0 ? [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withOpacity(sparkle * 0.25),
                              blurRadius: 20,
                            ),
                          ] : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                instruction.substring(0, visibleChars) + (typing > 0 && typing < 1 ? '│' : ''),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (sparkle > 0)
                              Opacity(
                                opacity: sparkle,
                                child: const Icon(Icons.auto_awesome, color: Color(0xFFF59E0B), size: 22),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 55),
                  
                  _AnimatedHeadline(
                    controller: controller,
                    delay: 0.4,
                    text: 'Refine & Perfect',
                  ),
                  const SizedBox(height: 14),
                  _AnimatedSubhead(
                    controller: controller,
                    delay: 0.48,
                    text: 'Not quite right? Just tell the AI\nwhat to change until it\'s perfect.',
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
// FRAME 6: HIGHLIGHT & TRANSFORM
// "Highlight any text to rewrite, summarize, or fix in seconds."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene6Highlight extends StatelessWidget {
  final AnimationController controller;
  const _Scene6Highlight({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final fadeIn = Curves.easeOut.transform((controller.value / 0.15).clamp(0.0, 1.0));
        final fadeOut = controller.value > 0.85 ? Curves.easeIn.transform(((controller.value - 0.85) / 0.15).clamp(0.0, 1.0)) : 0.0;
        final opacity = fadeIn * (1 - fadeOut);
        
        final textAppear = Curves.easeOut.transform(((controller.value - 0.1) / 0.12).clamp(0.0, 1.0));
        final highlightSweep = Curves.easeInOut.transform(((controller.value - 0.22) / 0.28).clamp(0.0, 1.0));
        final transform = Curves.easeOut.transform(((controller.value - 0.52) / 0.15).clamp(0.0, 1.0));

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Original text
                  Opacity(
                    opacity: textAppear,
                    child: Stack(
                      children: [
                        Text(
                          'fix this paragraph',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              const Color(0xFFF59E0B),
                              const Color(0xFFF59E0B),
                              Colors.transparent,
                              Colors.transparent,
                            ],
                            stops: [0, (highlightSweep - 0.02).clamp(0.0, 1.0), highlightSweep, 1],
                          ).createShader(bounds),
                          blendMode: BlendMode.srcIn,
                          child: const Text(
                            'fix this paragraph',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Arrow
                  Opacity(
                    opacity: transform,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      color: const Color(0xFFF59E0B).withOpacity(0.5),
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Transformed text
                  Opacity(
                    opacity: transform,
                    child: Transform.translate(
                      offset: Offset(0, 8 * (1 - transform)),
                      child: Text(
                        'polished to perfection',
                        style: TextStyle(
                          color: const Color(0xFFF59E0B),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(color: const Color(0xFFF59E0B).withOpacity(0.35), blurRadius: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 55),
                  
                  _AnimatedHeadline(
                    controller: controller,
                    delay: 0.45,
                    text: 'Highlight & Transform',
                  ),
                  const SizedBox(height: 14),
                  _AnimatedSubhead(
                    controller: controller,
                    delay: 0.52,
                    text: 'Highlight any text to rewrite,\nsummarize, or fix in seconds.',
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
// FRAME 7: THE OUTCOME (THE MAGIC PULL)
// "Speak your mind. Let AI pull the plans, to-dos, and alarms for you."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene7Outcome extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;
  const _Scene7Outcome({required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ('Call Sarah at 3pm', true),
      ('Send the report', false),
      ('Book flight to NYC', true),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final fadeIn = Curves.easeOut.transform((controller.value / 0.15).clamp(0.0, 1.0));
        final fadeOut = controller.value > 0.85 ? Curves.easeIn.transform(((controller.value - 0.85) / 0.15).clamp(0.0, 1.0)) : 0.0;
        final opacity = fadeIn * (1 - fadeOut);

        // Waveform
        final waveAppear = Curves.easeOut.transform(((controller.value - 0.08) / 0.12).clamp(0.0, 1.0));
        // Arrow
        final arrowAppear = Curves.easeOut.transform(((controller.value - 0.25) / 0.1).clamp(0.0, 1.0));

        return Opacity(
          opacity: opacity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Waveform
                  Opacity(
                    opacity: waveAppear,
                    child: SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          final wave = math.sin((loopController.value * math.pi * 2) + (i * 0.8));
                          final height = 15 + (wave.abs() * 28);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 5,
                            height: height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                              ),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.4), blurRadius: 8),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Arrow
                  Opacity(
                    opacity: arrowAppear,
                    child: Icon(Icons.arrow_downward_rounded, color: Colors.white.withOpacity(0.25), size: 22),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Task list
                  ...List.generate(tasks.length, (i) {
                    final delay = 0.32 + (i * 0.08);
                    final taskAppear = Curves.easeOut.transform(((controller.value - delay) / 0.12).clamp(0.0, 1.0));
                    final task = tasks[i];
                    
                    return Opacity(
                      opacity: taskAppear,
                      child: Transform.translate(
                        offset: Offset(-20 * (1 - taskAppear), 0),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF06B6D4)]),
                                ),
                                child: const Icon(Icons.check, color: Colors.white, size: 13),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                task.$1,
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              if (task.$2) ...[
                                const SizedBox(width: 10),
                                const Icon(Icons.alarm_rounded, color: Color(0xFFF59E0B), size: 16),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 45),
                  
                  _AnimatedHeadline(
                    controller: controller,
                    delay: 0.55,
                    text: 'Speak your mind.',
                  ),
                  const SizedBox(height: 14),
                  _AnimatedSubhead(
                    controller: controller,
                    delay: 0.62,
                    text: 'Let AI pull the plans, to-dos,\nand alarms for you.',
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
// FINALE: POWER AT YOUR FINGERTIPS
// ═══════════════════════════════════════════════════════════════════════════

class _Finale extends StatefulWidget {
  final AnimationController loopController;
  final AnimationController pulseController;
  final VoidCallback onComplete;
  const _Finale({required this.loopController, required this.pulseController, required this.onComplete});
  
  @override
  State<_Finale> createState() => _FinaleState();
}

class _FinaleState extends State<_Finale> with SingleTickerProviderStateMixin {
  late AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_revealController, widget.pulseController]),
      builder: (context, _) {
        final logoAppear = Curves.easeOut.transform((_revealController.value / 0.35).clamp(0.0, 1.0));
        final text1Appear = Curves.easeOut.transform(((_revealController.value - 0.2) / 0.25).clamp(0.0, 1.0));
        final text2Appear = Curves.easeOut.transform(((_revealController.value - 0.35) / 0.25).clamp(0.0, 1.0));
        final buttonAppear = Curves.easeOut.transform(((_revealController.value - 0.55) / 0.45).clamp(0.0, 1.0));
        final glow = 0.35 + (widget.pulseController.value * 0.2);

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Opacity(
                  opacity: logoAppear,
                  child: Transform.scale(
                    scale: 0.85 + (logoAppear * 0.15),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(glow),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/app_logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              ),
                            ),
                            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 48),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Headline
                Opacity(
                  opacity: text1Appear,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - text1Appear)),
                    child: const Text(
                      'Power at your fingertips.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.2,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subhead
                Opacity(
                  opacity: text2Appear,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - text2Appear)),
                    child: Text(
                      'Import. Process. Finish.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Button
                Opacity(
                  opacity: buttonAppear,
                  child: Transform.translate(
                    offset: Offset(0, 15 * (1 - buttonAppear)),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                        widget.onComplete();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.4),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
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
// HELPERS
// ═══════════════════════════════════════════════════════════════════════════

class _AnimatedHeadline extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final String text;
  const _AnimatedHeadline({required this.controller, required this.delay, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = Curves.easeOut.transform(((controller.value - delay) / 0.15).clamp(0.0, 1.0));
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - progress)),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedSubhead extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final String text;
  const _AnimatedSubhead({required this.controller, required this.delay, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final progress = Curves.easeOut.transform(((controller.value - delay) / 0.15).clamp(0.0, 1.0));
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - progress)),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DocLine extends StatelessWidget {
  final double width;
  const _DocLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Container(
        height: 7,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
