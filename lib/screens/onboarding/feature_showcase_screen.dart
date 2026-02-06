import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

/// ═══════════════════════════════════════════════════════════════════════════
/// THE GREATEST ONBOARDING EVER MADE - V2
/// ═══════════════════════════════════════════════════════════════════════════
///
/// FIXES APPLIED:
/// 1. AI Presets - pink glow cycles through ALL options
/// 2. Highlight to AI - way more elite animation
/// 3. Image to Text - shows actual text appearing from scan
/// 4. Import - beautiful 3D-style file icons with glow
/// 5. Finale - uses real app logo from assets/app_logo.png
/// 6. Added new scene: Highlight Text + AI Rewrite
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
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _loopController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _playScene();
  }

  void _playScene() {
    _controller.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
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
      _controller.stop();
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
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < -300) _nextScene();
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // The scene
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _buildScene(_scene),
            ),
            
            // Skip button
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: GestureDetector(
                onTap: _skip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 30,
                  top: 20,
                ),
                child: Column(
                  children: [
                    // Tap hint
                    if (_scene < _totalScenes - 1)
                      Text(
                        'tap to continue',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Progress dots
                    _buildProgressDots(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalScenes, (i) {
        final isActive = i == _scene;
        final isPast = i < _scene;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isPast
                ? Colors.white.withOpacity(0.4)
                : isActive
                    ? Colors.white
                    : Colors.white.withOpacity(0.15),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 8)]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildScene(int scene) {
    switch (scene) {
      case 0:
        return _Scene1VoiceToText(key: const ValueKey(0), controller: _controller, loopController: _loopController);
      case 1:
        return _Scene2AIPresets(key: const ValueKey(1), controller: _controller, loopController: _loopController);
      case 2:
        return _Scene3HighlightAI(key: const ValueKey(2), controller: _controller);
      case 3:
        return _Scene4ImageToText(key: const ValueKey(3), controller: _controller);
      case 4:
        return _Scene5Import(key: const ValueKey(4), controller: _controller, loopController: _loopController);
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
// SCENE 1: VOICE TO TEXT - Voice waves + letter by letter text
// ═══════════════════════════════════════════════════════════════════════════

class _Scene1VoiceToText extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _Scene1VoiceToText({super.key, required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final wavePhase = (controller.value * 2).clamp(0.0, 1.0);
        final textPhase = ((controller.value - 0.4) * 1.67).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing voice waves
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(9, (i) {
                      final offset = (i - 4).abs() * 0.12;
                      final wave = math.sin((loopController.value * math.pi * 2) + (i * 0.5));
                      final height = 20 + (wave.abs() * 60 * wavePhase);
                      final opacity = wavePhase * (1 - offset * 0.5);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
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
                              color: const Color(0xFF3B82F6).withOpacity(opacity * 0.6),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 60),

                // Text appearing letter by letter
                _TypewriterText(
                  text: 'Speak.',
                  progress: textPhase,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                _TypewriterText(
                  text: 'Watch it write.',
                  progress: textPhase,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.5,
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

class _TypewriterText extends StatelessWidget {
  final String text;
  final double progress;
  final TextStyle style;

  const _TypewriterText({
    required this.text,
    required this.progress,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final chars = (text.length * progress).ceil().clamp(0, text.length);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text.substring(0, chars),
          style: style,
        ),
        // Blinking cursor
        if (progress > 0 && progress < 1)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: (progress * 10 % 1) > 0.5 ? 1 : 0,
            child: Container(
              width: 3,
              height: style.fontSize! * 0.8,
              margin: const EdgeInsets.only(left: 2),
              color: const Color(0xFF3B82F6),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 2: AI PRESETS - Glow cycles through ALL options
// ═══════════════════════════════════════════════════════════════════════════

class _Scene2AIPresets extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _Scene2AIPresets({super.key, required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    final presets = ['Email', 'Notes', 'Social', 'Recipe', 'Summary', 'Story'];

    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        // Cycle through presets using loop controller
        final activeIndex = (loopController.value * presets.length).floor() % presets.length;
        
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
                const SizedBox(height: 4),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.value > 0.15 ? 1 : 0,
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

                // Preset chips - glow cycles through them
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 14,
                  children: List.generate(presets.length, (i) {
                    final delay = i * 0.08;
                    final appear = ((controller.value - 0.2 - delay) * 4).clamp(0.0, 1.0);
                    final isActive = i == activeIndex && controller.value > 0.5;

                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - appear)),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: appear,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: isActive ? null : Colors.white.withOpacity(0.08),
                            gradient: isActive
                                ? const LinearGradient(
                                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                                  )
                                : null,
                            border: Border.all(
                              color: isActive 
                                  ? Colors.transparent 
                                  : Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFEC4899).withOpacity(0.5),
                                      blurRadius: 25,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            presets[i],
                            style: TextStyle(
                              color: Colors.white.withOpacity(isActive ? 1 : 0.6),
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
// SCENE 3: HIGHLIGHT TO AI - Elite animation with highlight sweep + rewrite
// ═══════════════════════════════════════════════════════════════════════════

class _Scene3HighlightAI extends StatelessWidget {
  final AnimationController controller;

  const _Scene3HighlightAI({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final textAppear = (controller.value * 3).clamp(0.0, 1.0);
        final highlightSweep = ((controller.value - 0.2) * 2.5).clamp(0.0, 1.0);
        final sparkle = ((controller.value - 0.5) * 4).clamp(0.0, 1.0);
        final transformText = ((controller.value - 0.65) * 2.85).clamp(0.0, 1.0);
        final originalFade = transformText > 0 ? 1.0 - transformText : 1.0;
        
        return Container(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Original text with highlight effect
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: textAppear,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background text
                        Opacity(
                          opacity: originalFade,
                          child: Text(
                            'Need to fix this text',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Highlight sweep
                        if (highlightSweep > 0)
                          ClipRect(
                            clipper: _SweepClipper(highlightSweep),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFF59E0B).withOpacity(0.4),
                                    const Color(0xFFEF4444).withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Need to fix this text',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(originalFade),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Sparkle + AI indicator
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: sparkle,
                    child: Transform.scale(
                      scale: 0.8 + (sparkle * 0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SparkleIcon(progress: sparkle),
                          const SizedBox(width: 10),
                          Text(
                            'AI transforming...',
                            style: TextStyle(
                              color: const Color(0xFFF59E0B).withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Transformed text
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: transformText,
                    child: Transform.translate(
                      offset: Offset(0, 15 * (1 - transformText)),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                        ).createShader(bounds),
                        child: const Text(
                          'Polished to perfection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Label
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: textAppear,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Text(
                        'Highlight → AI Rewrite',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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

class _SweepClipper extends CustomClipper<Rect> {
  final double progress;
  _SweepClipper(this.progress);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * progress, size.height);

  @override
  bool shouldReclip(_SweepClipper old) => old.progress != progress;
}

class _SparkleIcon extends StatelessWidget {
  final double progress;
  const _SparkleIcon({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _SparklePainter(progress: progress),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final double progress;
  _SparklePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw 4-point star
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) - math.pi / 2;
      final outerPoint = Offset(
        center.dx + math.cos(angle) * radius * progress,
        center.dy + math.sin(angle) * radius * progress,
      );
      final innerAngle = angle + math.pi / 4;
      final innerPoint = Offset(
        center.dx + math.cos(innerAngle) * radius * 0.3,
        center.dy + math.sin(innerAngle) * radius * 0.3,
      );
      
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklePainter old) => old.progress != progress;
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 4: IMAGE TO TEXT - Scan shows actual text appearing
// ═══════════════════════════════════════════════════════════════════════════

class _Scene4ImageToText extends StatelessWidget {
  final AnimationController controller;

  const _Scene4ImageToText({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final frameAppear = (controller.value * 2.5).clamp(0.0, 1.0);
        final scanProgress = ((controller.value - 0.25) * 2).clamp(0.0, 1.0);
        final textReveal = ((controller.value - 0.5) * 2).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image frame with scan and text appearing
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: frameAppear,
                  child: Transform.scale(
                    scale: 0.9 + (frameAppear * 0.1),
                    child: Container(
                      width: 260,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.6),
                          width: 2,
                        ),
                        color: Colors.white.withOpacity(0.03),
                      ),
                      child: Stack(
                        children: [
                          // "Document" content - faded lines
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDocLine(0.9, 0.4),
                                const SizedBox(height: 8),
                                _buildDocLine(0.7, 0.3),
                                const SizedBox(height: 8),
                                _buildDocLine(0.8, 0.35),
                                const SizedBox(height: 8),
                                _buildDocLine(0.5, 0.3),
                              ],
                            ),
                          ),
                          
                          // Scan line with glow
                          if (scanProgress > 0 && scanProgress < 1)
                            Positioned(
                              top: scanProgress * 160,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF10B981),
                                      const Color(0xFF10B981),
                                      Colors.transparent,
                                    ],
                                    stops: const [0, 0.2, 0.8, 1],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF10B981).withOpacity(0.8),
                                      blurRadius: 20,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          // Extracted text overlay
                          if (textReveal > 0)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.black.withOpacity(0.7 * textReveal),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Opacity(
                                  opacity: textReveal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Meeting Notes',
                                        style: TextStyle(
                                          color: const Color(0xFF10B981),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Review Q4 targets\nDiscuss roadmap\nAssign action items',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // Title
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: textReveal,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - textReveal)),
                    child: Column(
                      children: [
                        const Text(
                          'Image → Text',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'extracted instantly',
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: 22,
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

  Widget _buildDocLine(double width, double opacity) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 5: IMPORT - Beautiful 3D-style file icons
// ═══════════════════════════════════════════════════════════════════════════

class _Scene5Import extends StatelessWidget {
  final AnimationController controller;
  final AnimationController loopController;

  const _Scene5Import({super.key, required this.controller, required this.loopController});

  @override
  Widget build(BuildContext context) {
    final files = [
      ('PDF', const Color(0xFFEF4444), Icons.picture_as_pdf_rounded),
      ('DOC', const Color(0xFF3B82F6), Icons.description_rounded),
      ('IMG', const Color(0xFF10B981), Icons.image_rounded),
      ('MP3', const Color(0xFF8B5CF6), Icons.audiotrack_rounded),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([controller, loopController]),
      builder: (context, _) {
        final titleAppear = (controller.value * 2.5).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // File icons with 3D effect
                SizedBox(
                  height: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(files.length, (i) {
                      final delay = i * 0.1;
                      final progress = ((controller.value - delay) * 2.5).clamp(0.0, 1.0);
                      final float = math.sin((loopController.value * math.pi * 2) + (i * 0.8)) * 6;
                      final file = files[i];

                      return Transform.translate(
                        offset: Offset(0, float + (30 * (1 - progress))),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: progress,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon with glow
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        file.$2,
                                        file.$2.withOpacity(0.7),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: file.$2.withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    file.$3,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  file.$1,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 50),

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
        final textAppear = ((controller.value - 0.3) * 1.43).clamp(0.0, 1.0);
        final float = math.sin(loopController.value * math.pi * 2) * 10;
        final pulse = 1.0 + math.sin(loopController.value * math.pi * 4) * 0.05;

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Floating bubble with glow
                Transform.translate(
                  offset: Offset(0, float),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: bubbleAppear,
                    child: Transform.scale(
                      scale: (0.8 + (bubbleAppear * 0.2)) * pulse,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.6),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: 48,
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
                          'Access from anywhere.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 20,
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
// SCENE 7: CONTINUE WITH AI - Chat conversation
// ═══════════════════════════════════════════════════════════════════════════

class _Scene7ContinueAI extends StatelessWidget {
  final AnimationController controller;

  const _Scene7ContinueAI({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final msg1 = (controller.value * 2.5).clamp(0.0, 1.0);
        final msg2 = ((controller.value - 0.2) * 2.5).clamp(0.0, 1.0);
        final msg3 = ((controller.value - 0.4) * 2.5).clamp(0.0, 1.0);
        final title = ((controller.value - 0.6) * 2.5).clamp(0.0, 1.0);

        return Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Chat messages
                _ChatBubble(text: 'Make it longer', isUser: true, progress: msg1),
                const SizedBox(height: 14),
                _ChatBubble(text: 'Done! Added more detail ✨', isUser: false, progress: msg2),
                const SizedBox(height: 14),
                _ChatBubble(text: 'Now make it casual', isUser: true, progress: msg3),

                const SizedBox(height: 50),

                // Title
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: title,
                  child: Transform.translate(
                    offset: Offset(0, 15 * (1 - title)),
                    child: const Text(
                      'Continue the\nconversation.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
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

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final double progress;

  const _ChatBubble({
    required this.text,
    required this.isUser,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: progress,
      child: Transform.translate(
        offset: Offset((isUser ? 30 : -30) * (1 - progress), 0),
        child: Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: isUser
                  ? const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)])
                  : null,
              color: isUser ? null : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomRight: isUser ? const Radius.circular(4) : null,
                bottomLeft: !isUser ? const Radius.circular(4) : null,
              ),
              border: isUser ? null : Border.all(color: Colors.white.withOpacity(0.1)),
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
// SCENE 8: FINALE - Uses real app logo
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
        final textAppear = ((controller.value - 0.25) * 2).clamp(0.0, 1.0);
        final buttonAppear = ((controller.value - 0.5) * 2).clamp(0.0, 1.0);
        final glow = 0.4 + (math.sin(loopController.value * math.pi * 2) * 0.3);
        final pulse = 1.0 + math.sin(loopController.value * math.pi * 4) * 0.02;

        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Real app logo with glow
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: logoAppear,
                  child: Transform.scale(
                    scale: (0.8 + (logoAppear * 0.2)) * pulse,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(glow),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(glow * 0.5),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.asset(
                          'assets/app_logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              ),
                            ),
                            child: const Icon(Icons.mic, color: Colors.white, size: 56),
                          ),
                        ),
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
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your voice, transformed.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
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
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          onComplete();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.4),
                                blurRadius: 25,
                                offset: const Offset(0, 12),
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
                                letterSpacing: 0.5,
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
