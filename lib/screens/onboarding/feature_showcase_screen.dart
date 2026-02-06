import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

/// ═══════════════════════════════════════════════════════════════════════════
/// THE GREATEST ONBOARDING EVER MADE
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Pure cinema. Dark canvas. Each feature gets its own unique animation.
/// No templates. No repeated layouts. Just visual storytelling.
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
  late AnimationController _controller;
  late AnimationController _loopController;
  
  int _scene = 0;
  final int _totalScenes = 8;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _loopController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _playScene();
  }

  void _playScene() {
    _controller.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && _scene < _totalScenes - 1) {
          setState(() => _scene++);
          _playScene();
        }
      });
    });
  }

  void _skip() {
    HapticFeedback.mediumImpact();
    widget.onComplete();
  }

  void _nextScene() {
    HapticFeedback.lightImpact();
    if (_scene < _totalScenes - 1) {
      setState(() => _scene++);
      _playScene();
    } else {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _nextScene,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // The scene
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: _buildScene(_scene),
            ),
            
            // Skip button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 20,
              child: GestureDetector(
                onTap: _skip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Progress bar
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 40,
              left: 40,
              right: 40,
              child: _buildProgressBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        // Tap to continue hint
        AnimatedOpacity(
          opacity: _scene < _totalScenes - 1 ? 0.5 : 0,
          duration: const Duration(milliseconds: 300),
          child: const Text(
            'tap to continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Progress dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_totalScenes, (i) {
            final isActive = i == _scene;
            final isPast = i < _scene;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isPast
                    ? Colors.white.withOpacity(0.5)
                    : isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.2),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildScene(int scene) {
    switch (scene) {
      case 0:
        return _Scene1VoiceToText(key: const ValueKey(0), controller: _controller);
      case 1:
        return _Scene2AIPresets(key: const ValueKey(1), controller: _controller);
      case 2:
        return _Scene3HighlightAI(key: const ValueKey(2), controller: _controller, loopController: _loopController);
      case 3:
        return _Scene4ImageToText(key: const ValueKey(3), controller: _controller);
      case 4:
        return _Scene5Import(key: const ValueKey(4), controller: _controller);
      case 5:
        return _Scene6FloatingBubble(key: const ValueKey(5), controller: _controller, loopController: _loopController);
      case 6:
        return _Scene7ContinueAI(key: const ValueKey(6), controller: _controller);
      case 7:
        return _Scene8Finale(key: const ValueKey(7), controller: _controller, loopController: _loopController, onComplete: widget.onComplete);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 1: VOICE TO TEXT
// Voice waves pulse, then text appears letter by letter
// ═══════════════════════════════════════════════════════════════════════════

class _Scene1VoiceToText extends StatelessWidget {
  final AnimationController controller;

  const _Scene1VoiceToText({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final wavePhase = (controller.value * 2).clamp(0.0, 1.0);
        final textPhase = ((controller.value - 0.4) * 1.67).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Voice waves
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(7, (i) {
                      final delay = i * 0.1;
                      final wave = math.sin((wavePhase * math.pi * 3) + delay * math.pi * 2);
                      final height = 20 + (wave.abs() * 50 * wavePhase);
                      final opacity = wavePhase;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 6,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF3B82F6).withOpacity(opacity),
                              const Color(0xFF8B5CF6).withOpacity(opacity),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(opacity * 0.5),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 60),

                // Text appearing letter by letter
                _buildRevealingText('Speak.', textPhase, 32, FontWeight.w300),
                const SizedBox(height: 8),
                _buildRevealingText('Watch it write.', textPhase, 48, FontWeight.w700),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevealingText(String text, double progress, double size, FontWeight weight) {
    final chars = (text.length * progress).floor();
    final visibleText = text.substring(0, chars);
    final opacity = progress > 0 ? 1.0 : 0.0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: Text(
        visibleText,
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 2: AI PRESETS
// Preset chips cascade down, one transforms with glow
// ═══════════════════════════════════════════════════════════════════════════

class _Scene2AIPresets extends StatelessWidget {
  final AnimationController controller;

  const _Scene2AIPresets({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final presets = ['Email', 'Notes', 'Social', 'Recipe', 'Summary', 'Story'];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.value > 0.1 ? 1 : 0,
                  child: const Text(
                    'One tap.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.value > 0.2 ? 1 : 0,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    ).createShader(bounds),
                    child: const Text(
                      'Perfect output.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // Preset chips
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(presets.length, (i) {
                    final delay = i * 0.1;
                    final appear = ((controller.value - 0.3 - delay) * 3).clamp(0.0, 1.0);
                    final isActive = i == 0 && controller.value > 0.7;

                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - appear)),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: appear,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isActive ? null : Colors.white.withOpacity(0.1),
                            gradient: isActive
                                ? const LinearGradient(
                                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                                  )
                                : null,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6).withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            presets[i],
                            style: TextStyle(
                              color: Colors.white.withOpacity(isActive ? 1 : 0.7),
                              fontSize: 16,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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
// SCENE 3: HIGHLIGHT TO AI
// Text with highlight sweep, then transforms
// ═══════════════════════════════════════════════════════════════════════════

class _Scene3HighlightAI extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _Scene3HighlightAI({super.key, required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final highlightProgress = ((controller.value - 0.2) * 2).clamp(0.0, 1.0);
        final transformProgress = ((controller.value - 0.6) * 2.5).clamp(0.0, 1.0);
        
        return Container(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Original text with highlight
                  Stack(
                    children: [
                      // Background text
                      Text(
                        'Make this sound better',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Highlight sweep
                      ClipRect(
                        clipper: _HighlightClipper(highlightProgress),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Make this sound better',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Transform indicator
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: controller.value > 0.5 ? 1 : 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: const Color(0xFFF59E0B).withOpacity(0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI rewriting...',
                          style: TextStyle(
                            color: const Color(0xFFF59E0B).withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Transformed text
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: transformProgress,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - transformProgress)),
                      child: const Text(
                        'Elevate this to perfection',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
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

class _HighlightClipper extends CustomClipper<Rect> {
  final double progress;
  _HighlightClipper(this.progress);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * progress, size.height);

  @override
  bool shouldReclip(_HighlightClipper old) => old.progress != progress;
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 4: IMAGE TO TEXT
// Image frame appears, scan line sweeps, text extracts
// ═══════════════════════════════════════════════════════════════════════════

class _Scene4ImageToText extends StatelessWidget {
  final AnimationController controller;

  const _Scene4ImageToText({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final frameAppear = (controller.value * 3).clamp(0.0, 1.0);
        final scanProgress = ((controller.value - 0.3) * 2).clamp(0.0, 1.0);
        final textAppear = ((controller.value - 0.7) * 3.3).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image frame with scan
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: frameAppear,
                  child: Transform.scale(
                    scale: 0.9 + (frameAppear * 0.1),
                    child: Container(
                      width: 200,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.5),
                          width: 2,
                        ),
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: Stack(
                        children: [
                          // Fake image content
                          Center(
                            child: Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          // Scan line
                          if (scanProgress > 0 && scanProgress < 1)
                            Positioned(
                              top: scanProgress * 140,
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
                                      blurRadius: 10,
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

                const SizedBox(height: 50),

                // Extracted text
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: textAppear,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - textAppear)),
                    child: Column(
                      children: [
                        const Text(
                          'Image → Text',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'in seconds',
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
// SCENE 5: IMPORT ANYTHING
// File icons float in from different directions
// ═══════════════════════════════════════════════════════════════════════════

class _Scene5Import extends StatelessWidget {
  final AnimationController controller;

  const _Scene5Import({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final files = [
      (Icons.picture_as_pdf, 'PDF', const Color(0xFFEF4444), const Offset(-100, -50)),
      (Icons.description, 'DOC', const Color(0xFF3B82F6), const Offset(100, -30)),
      (Icons.image, 'IMG', const Color(0xFF10B981), const Offset(-80, 50)),
      (Icons.audiotrack, 'MP3', const Color(0xFF8B5CF6), const Offset(90, 60)),
    ];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final titleAppear = (controller.value * 3).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // File icons floating in
                SizedBox(
                  height: 180,
                  width: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(files.length, (i) {
                      final delay = i * 0.15;
                      final progress = ((controller.value - delay) * 2.5).clamp(0.0, 1.0);
                      final file = files[i];

                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 100),
                        left: 140 + (file.$4.dx * (1 - progress)) - 30,
                        top: 90 + (file.$4.dy * (1 - progress)) - 30,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: progress,
                          child: Transform.scale(
                            scale: 0.5 + (progress * 0.5),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: file.$3.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: file.$3.withOpacity(0.4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: file.$3.withOpacity(0.3),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: Icon(
                                file.$1,
                                color: file.$3,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 40),

                // Text
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: titleAppear,
                  child: Column(
                    children: [
                      const Text(
                        'Import',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.5,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ).createShader(bounds),
                        child: const Text(
                          'anything.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.5,
                          ),
                        ),
                      ),
                    ],
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
// SCENE 6: FLOATING BUBBLE
// Bubble floats in, pulses, shows "anywhere" concept
// ═══════════════════════════════════════════════════════════════════════════

class _Scene6FloatingBubble extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _Scene6FloatingBubble({super.key, required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final bubbleAppear = (controller.value * 2).clamp(0.0, 1.0);
        final textAppear = ((controller.value - 0.4) * 1.67).clamp(0.0, 1.0);
        final float = math.sin(loopController.value * math.pi * 2) * 8;

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Floating bubble
                Transform.translate(
                  offset: Offset(0, float),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: bubbleAppear,
                    child: Transform.scale(
                      scale: 0.8 + (bubbleAppear * 0.2),
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
                        child: const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // Text
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: textAppear,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - textAppear)),
                    child: Column(
                      children: [
                        const Text(
                          'Floating bubble.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Access anywhere.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
// SCENE 7: CONTINUE WITH AI
// Chat bubbles appear in conversation style
// ═══════════════════════════════════════════════════════════════════════════

class _Scene7ContinueAI extends StatelessWidget {
  final AnimationController controller;

  const _Scene7ContinueAI({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final msg1 = (controller.value * 3).clamp(0.0, 1.0);
        final msg2 = ((controller.value - 0.25) * 3).clamp(0.0, 1.0);
        final msg3 = ((controller.value - 0.5) * 3).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User message
                _buildMessage(
                  'Make it longer',
                  isUser: true,
                  progress: msg1,
                ),
                const SizedBox(height: 16),
                // AI response
                _buildMessage(
                  'Done! Expanded with more detail.',
                  isUser: false,
                  progress: msg2,
                ),
                const SizedBox(height: 16),
                // User follow-up
                _buildMessage(
                  'Now more casual',
                  isUser: true,
                  progress: msg3,
                ),

                const SizedBox(height: 50),

                // Title
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: msg3,
                  child: const Text(
                    'Continue the\nconversation.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage(String text, {required bool isUser, required double progress}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: progress,
      child: Transform.translate(
        offset: Offset(isUser ? 20 : -20, 0) * (1 - progress),
        child: Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isUser
                  ? const Color(0xFF3B82F6)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomRight: isUser ? const Radius.circular(4) : null,
                bottomLeft: !isUser ? const Radius.circular(4) : null,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(isUser ? 1 : 0.8),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 8: FINALE
// Epic ending with logo and CTA
// ═══════════════════════════════════════════════════════════════════════════

class _Scene8Finale extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;
  final VoidCallback onComplete;

  const _Scene8Finale({
    super.key,
    required this.controller,
    required this.loopController,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final logoAppear = (controller.value * 2).clamp(0.0, 1.0);
        final textAppear = ((controller.value - 0.3) * 2).clamp(0.0, 1.0);
        final buttonAppear = ((controller.value - 0.6) * 2.5).clamp(0.0, 1.0);
        final glow = 0.4 + (math.sin(loopController.value * math.pi * 2) * 0.3);

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with glow
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: logoAppear,
                  child: Transform.scale(
                    scale: 0.8 + (logoAppear * 0.2),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(glow),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Text
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: textAppear,
                  child: Column(
                    children: [
                      const Text(
                        'VoiceBubble',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your voice, transformed.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // CTA Button
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: buttonAppear,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - buttonAppear)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: GestureDetector(
                        onTap: onComplete,
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
                                offset: const Offset(0, 10),
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
