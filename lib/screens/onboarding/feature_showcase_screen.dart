import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// ═══════════════════════════════════════════════════════════════════════════
/// 
///   ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗██████╗ ██╗   ██╗██████╗ ██████╗ ██╗     ███████╗
///   ██║   ██║██╔═══██╗██║██╔════╝██╔════╝██╔══██╗██║   ██║██╔══██╗██╔══██╗██║     ██╔════╝
///   ██║   ██║██║   ██║██║██║     █████╗  ██████╔╝██║   ██║██████╔╝██████╔╝██║     █████╗  
///   ╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝  ██╔══██╗██║   ██║██╔══██╗██╔══██╗██║     ██╔══╝  
///    ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗██████╔╝╚██████╔╝██████╔╝██████╔╝███████╗███████╗
///     ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝╚═════╝  ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝
///
///   THE CINEMA - ONE CONTINUOUS MOVIE
///   
///   No pages. No dots. No buttons. Just the experience.
///   Each moment hits. Fades. Next moment. Pure cinema.
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
  
  late AnimationController _masterController;
  late AnimationController _waveController;
  late AnimationController _glowController;
  
  // Total duration: ~18 seconds
  static const double _sceneDuration = 2.2;
  static const int _totalScenes = 8;
  
  int _currentScene = 0;
  bool _showingFinale = false;

  @override
  void initState() {
    super.initState();
    
    _masterController = AnimationController(
      duration: Duration(milliseconds: (_sceneDuration * 1000).toInt()),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _runCinema();
  }

  void _runCinema() async {
    for (int i = 0; i < _totalScenes; i++) {
      if (!mounted) return;
      
      setState(() => _currentScene = i);
      _masterController.forward(from: 0);
      
      await Future.delayed(Duration(milliseconds: (_sceneDuration * 1000).toInt() + 300));
    }
    
    // Show finale
    if (mounted) {
      setState(() => _showingFinale = true);
    }
  }

  void _skip() {
    HapticFeedback.mediumImpact();
    widget.onComplete();
  }

  @override
  void dispose() {
    _masterController.dispose();
    _waveController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main cinema
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _showingFinale 
                ? _FinaleScene(
                    key: const ValueKey('finale'),
                    glowController: _glowController,
                    onComplete: widget.onComplete,
                  )
                : _buildScene(_currentScene),
          ),
          
          // Skip button - subtle, top right
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: GestureDetector(
              onTap: _skip,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showingFinale ? 0 : 0.5,
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
        ],
      ),
    );
  }

  Widget _buildScene(int index) {
    switch (index) {
      case 0:
        return _Scene1Voice(
          key: const ValueKey(0),
          master: _masterController,
          wave: _waveController,
        );
      case 1:
        return _Scene2Presets(
          key: const ValueKey(1),
          master: _masterController,
          glow: _glowController,
        );
      case 2:
        return _Scene3Highlight(
          key: const ValueKey(2),
          master: _masterController,
        );
      case 3:
        return _Scene4Import(
          key: const ValueKey(3),
          master: _masterController,
          glow: _glowController,
        );
      case 4:
        return _Scene5ImageToText(
          key: const ValueKey(4),
          master: _masterController,
        );
      case 5:
        return _Scene6VoiceToTasks(
          key: const ValueKey(5),
          master: _masterController,
        );
      case 6:
        return _Scene7Batch(
          key: const ValueKey(6),
          master: _masterController,
        );
      case 7:
        return _Scene8Anywhere(
          key: const ValueKey(7),
          master: _masterController,
          glow: _glowController,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 1: VOICE WAVEFORM - "Speak. AI Amplifies. Done."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene1Voice extends StatelessWidget {
  final AnimationController master;
  final AnimationController wave;

  const _Scene1Voice({super.key, required this.master, required this.wave});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([master, wave]),
      builder: (context, _) {
        final appear = Curves.easeOut.transform((master.value * 3).clamp(0.0, 1.0));
        final textAppear = Curves.easeOut.transform(((master.value - 0.3) * 2).clamp(0.0, 1.0));
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // WAVEFORM
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(9, (i) {
                        final offset = (i - 4).abs();
                        final waveVal = math.sin((wave.value * math.pi * 2) + (i * 0.6));
                        final height = 16 + (waveVal.abs() * 55 * appear);
                        final barOpacity = appear * (1 - offset * 0.1);

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 5,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF3B82F6).withOpacity(barOpacity),
                                const Color(0xFF8B5CF6).withOpacity(barOpacity),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(barOpacity * 0.6),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // TEXT
                  Opacity(
                    opacity: textAppear,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - textAppear)),
                      child: Column(
                        children: [
                          const Text(
                            'Speak.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -2,
                              height: 1.1,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                            ).createShader(bounds),
                            child: const Text(
                              'AI Amplifies.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -2,
                                height: 1.1,
                              ),
                            ),
                          ),
                          const Text(
                            'Done.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -2,
                              height: 1.1,
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
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 2: PRESETS - "20+ Presets. One Tap Perfection."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene2Presets extends StatelessWidget {
  final AnimationController master;
  final AnimationController glow;

  const _Scene2Presets({super.key, required this.master, required this.glow});

  @override
  Widget build(BuildContext context) {
    // Preset data: name, color
    final presets = [
      ('Magic', const Color(0xFF9333EA)),
      ('Email', const Color(0xFFDC2626)),
      ('Social', const Color(0xFFEC4899)),
      ('Poem', const Color(0xFFF59E0B)),
      ('Notes', const Color(0xFF10B981)),
      ('+15', const Color(0xFF6366F1)),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([master, glow]),
      builder: (context, _) {
        final textAppear = Curves.easeOut.transform((master.value * 2.5).clamp(0.0, 1.0));
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;
        final activeIndex = (glow.value * presets.length).floor() % presets.length;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // PRESET CHIPS
                  Opacity(
                    opacity: textAppear,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(presets.length, (i) {
                        final delay = i * 0.08;
                        final chipAppear = ((master.value - delay) * 4).clamp(0.0, 1.0);
                        final isActive = i == activeIndex && master.value > 0.4;
                        final preset = presets[i];

                        return Transform.translate(
                          offset: Offset(0, 15 * (1 - chipAppear)),
                          child: Opacity(
                            opacity: chipAppear,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: isActive ? preset.$2 : preset.$2.withOpacity(0.15),
                                border: Border.all(
                                  color: preset.$2.withOpacity(isActive ? 0 : 0.4),
                                  width: 1.5,
                                ),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: preset.$2.withOpacity(0.6),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                preset.$1,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(isActive ? 1 : 0.8),
                                  fontSize: 15,
                                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // TEXT
                  Opacity(
                    opacity: textAppear,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - textAppear)),
                      child: Column(
                        children: [
                          const Text(
                            '20+ Presets.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 44,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.5,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                            ).createShader(bounds),
                            child: const Text(
                              'One Tap Perfection.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.5,
                              ),
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
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 3: HIGHLIGHT - "Highlight. Transform."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene3Highlight extends StatelessWidget {
  final AnimationController master;

  const _Scene3Highlight({super.key, required this.master});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: master,
      builder: (context, _) {
        final appear = Curves.easeOut.transform((master.value * 2.5).clamp(0.0, 1.0));
        final highlightSweep = Curves.easeInOut.transform(((master.value - 0.2) * 2).clamp(0.0, 1.0));
        final transform = Curves.easeOut.transform(((master.value - 0.55) * 2.5).clamp(0.0, 1.0));
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Highlight demo
                  Opacity(
                    opacity: appear,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: Stack(
                        children: [
                          // Base text
                          Text(
                            'Make this better',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Highlight sweep
                          ClipRect(
                            clipper: _SweepClipper(highlightSweep),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFF59E0B).withOpacity(0.5),
                                    const Color(0xFFEF4444).withOpacity(0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Make this better',
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
                  ),

                  const SizedBox(height: 20),

                  // Arrow + sparkle
                  Opacity(
                    opacity: transform,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      color: const Color(0xFFF59E0B).withOpacity(0.7),
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Transformed result
                  Opacity(
                    opacity: transform,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - transform)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFF59E0B).withOpacity(0.15),
                              const Color(0xFFEF4444).withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0xFFF59E0B).withOpacity(0.3),
                          ),
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                          ).createShader(bounds),
                          child: const Text(
                            'Elevated to perfection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Label
                  Opacity(
                    opacity: appear,
                    child: Column(
                      children: [
                        const Text(
                          'Highlight.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                          ).createShader(bounds),
                          child: const Text(
                            'Transform.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
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

// ═══════════════════════════════════════════════════════════════════════════
// SCENE 4: IMPORT/EXPORT - "Import/Export Anything."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene4Import extends StatelessWidget {
  final AnimationController master;
  final AnimationController glow;

  const _Scene4Import({super.key, required this.master, required this.glow});

  @override
  Widget build(BuildContext context) {
    final files = [
      (Icons.picture_as_pdf_rounded, 'PDF', const Color(0xFFEF4444)),
      (Icons.description_rounded, 'DOC', const Color(0xFF3B82F6)),
      (Icons.image_rounded, 'IMG', const Color(0xFF10B981)),
      (Icons.audiotrack_rounded, 'MP3', const Color(0xFF8B5CF6)),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([master, glow]),
      builder: (context, _) {
        final appear = Curves.easeOut.transform((master.value * 2.5).clamp(0.0, 1.0));
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // File icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(files.length, (i) {
                      final delay = i * 0.1;
                      final iconAppear = ((master.value - delay) * 3).clamp(0.0, 1.0);
                      final float = math.sin((glow.value * math.pi * 2) + (i * 1.2)) * 6;
                      final file = files[i];

                      return Transform.translate(
                        offset: Offset(0, float + (20 * (1 - iconAppear))),
                        child: Opacity(
                          opacity: iconAppear,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [file.$3, file.$3.withOpacity(0.7)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: file.$3.withOpacity(0.5),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Icon(file.$1, color: Colors.white, size: 28),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  file.$2,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 11,
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

                  const SizedBox(height: 50),

                  // Text
                  Opacity(
                    opacity: appear,
                    child: Transform.translate(
                      offset: Offset(0, 15 * (1 - appear)),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ).createShader(bounds),
                        child: const Text(
                          'Import/Export Anything.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
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
// SCENE 5: IMAGE TO TEXT - "Instant Image to Text."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene5ImageToText extends StatelessWidget {
  final AnimationController master;

  const _Scene5ImageToText({super.key, required this.master});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: master,
      builder: (context, _) {
        final appear = Curves.easeOut.transform((master.value * 2.5).clamp(0.0, 1.0));
        final scanProgress = ((master.value - 0.2) * 1.8).clamp(0.0, 1.0);
        final textReveal = ((master.value - 0.5) * 2.5).clamp(0.0, 1.0);
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image frame with scan
                  Opacity(
                    opacity: appear,
                    child: Container(
                      width: 200,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.5),
                          width: 2,
                        ),
                        color: Colors.white.withOpacity(0.03),
                      ),
                      child: Stack(
                        children: [
                          // Placeholder lines
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(4, (i) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  width: [140.0, 100.0, 120.0, 80.0][i],
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
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
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Extracted text preview
                  Opacity(
                    opacity: textReveal,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - textReveal)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                        ),
                        child: Text(
                          '"Meeting at 3pm tomorrow..."',
                          style: TextStyle(
                            color: const Color(0xFF10B981),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Label
                  Opacity(
                    opacity: appear,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                      ).createShader(bounds),
                      child: const Text(
                        'Instant Image to Text.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
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
// SCENE 6: VOICE TO TASKS - "Voice to Tasks."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene6VoiceToTasks extends StatelessWidget {
  final AnimationController master;

  const _Scene6VoiceToTasks({super.key, required this.master});

  @override
  Widget build(BuildContext context) {
    final tasks = ['Call Sarah', 'Send report', 'Book flight'];

    return AnimatedBuilder(
      animation: master,
      builder: (context, _) {
        final appear = Curves.easeOut.transform((master.value * 2.5).clamp(0.0, 1.0));
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tasks appearing
                  ...List.generate(tasks.length, (i) {
                    final delay = 0.15 + (i * 0.12);
                    final taskAppear = ((master.value - delay) * 3.5).clamp(0.0, 1.0);

                    return Opacity(
                      opacity: taskAppear,
                      child: Transform.translate(
                        offset: Offset(-30 * (1 - taskAppear), 0),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                                  ),
                                ),
                                child: const Icon(Icons.check, color: Colors.white, size: 14),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tasks[i],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
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
                  Opacity(
                    opacity: appear,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                      ).createShader(bounds),
                      child: const Text(
                        'Voice to Tasks.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
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
// SCENE 7: BATCH - "Process in Batches."
// ═══════════════════════════════════════════════════════════════════════════

class _Scene7Batch extends StatelessWidget {
  final AnimationController master;

  const _Scene7Batch({super.key, required this.master});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: master,
      builder: (context, _) {
        final appear = Curves.easeOut.transform((master.value * 2.5).clamp(0.0, 1.0));
        final progress = ((master.value - 0.2) * 1.5).clamp(0.0, 1.0);
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Multiple docs merging
                  Opacity(
                    opacity: appear,
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: List.generate(5, (i) {
                          final offset = (i - 2) * 25.0;
                          final moveProgress = progress;
                          final currentOffset = offset * (1 - moveProgress);

                          return Transform.translate(
                            offset: Offset(currentOffset, 0),
                            child: Container(
                              width: 50,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF6366F1).withOpacity(0.8 - (i * 0.1)),
                                    const Color(0xFF8B5CF6).withOpacity(0.6 - (i * 0.1)),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.3),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.description,
                                color: Colors.white.withOpacity(0.8),
                                size: 24,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Counter
                  Opacity(
                    opacity: appear,
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: const Color(0xFF8B5CF6),
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Label
                  Opacity(
                    opacity: appear,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ).createShader(bounds),
                      child: const Text(
                        'Process in Batches.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
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
// SCENE 8: ANYWHERE - "Anywhere." (Floating Bubble)
// ═══════════════════════════════════════════════════════════════════════════

class _Scene8Anywhere extends StatelessWidget {
  final AnimationController master;
  final AnimationController glow;

  const _Scene8Anywhere({super.key, required this.master, required this.glow});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([master, glow]),
      builder: (context, _) {
        final appear = Curves.easeOut.transform((master.value * 2.5).clamp(0.0, 1.0));
        final float = math.sin(glow.value * math.pi * 2) * 10;
        final fadeOut = master.value > 0.85 ? ((master.value - 0.85) * 6.67).clamp(0.0, 1.0) : 0.0;

        return Opacity(
          opacity: 1 - fadeOut,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Floating bubble
                  Transform.translate(
                    offset: Offset(0, float),
                    child: Opacity(
                      opacity: appear,
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
                              spreadRadius: 8,
                            ),
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                              blurRadius: 50,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Label
                  Opacity(
                    opacity: appear,
                    child: const Text(
                      'Anywhere.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
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
// FINALE - Logo + "100x Your Voice. Your Docs." + Get Started
// ═══════════════════════════════════════════════════════════════════════════

class _FinaleScene extends StatelessWidget {
  final AnimationController glowController;
  final VoidCallback onComplete;

  const _FinaleScene({
    super.key,
    required this.glowController,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowController,
      builder: (context, _) {
        final glow = 0.4 + (math.sin(glowController.value * math.pi * 2) * 0.3);

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, appear, _) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with glow
                    Transform.scale(
                      scale: 0.8 + (appear * 0.2),
                      child: Opacity(
                        opacity: appear,
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

                    // Tagline
                    Opacity(
                      opacity: appear,
                      child: Column(
                        children: [
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
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Get Started button
                    Opacity(
                      opacity: appear,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - appear)),
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
      },
    );
  }
}
