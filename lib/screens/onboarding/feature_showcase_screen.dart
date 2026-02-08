import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// ═══════════════════════════════════════════════════════════════════════════
/// VOICEBUBBLE ONBOARDING - THE MASTERPIECE
/// ═══════════════════════════════════════════════════════════════════════════

class FeatureShowcaseScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FeatureShowcaseScreen({super.key, required this.onComplete});
  
  @override
  State<FeatureShowcaseScreen> createState() => _FeatureShowcaseScreenState();
}

class _FeatureShowcaseScreenState extends State<FeatureShowcaseScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _loopController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  int _currentPage = 0;
  static const int _totalPages = 9;

  @override
  void initState() {
    super.initState();
    _loopController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loopController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF0A0A0A), Color(0xFF0A0A0A)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) => Opacity(opacity: _fadeAnimation.value, child: child),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _Page1Voice(loopController: _loopController),
                      _Page2Presets(loopController: _loopController),
                      _Page3Languages(loopController: _loopController),
                      _Page4Anywhere(loopController: _loopController),
                      _Page5Library(loopController: _loopController),
                      _Page7Share(loopController: _loopController),
                      _PageRefine(loopController: _loopController),
                      _PageOutcomes(),
                      _PageFinale(loopController: _loopController),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            _currentPage == _totalPages - 1 ? 'Get Started' : 'Continue',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAGE 1: SPEAK. AI WRITES. DONE.
// ═══════════════════════════════════════════════════════════════════════════

class _Page1Voice extends StatelessWidget {
  final AnimationController loopController;
  const _Page1Voice({required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loopController,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(3, (i) {
                      final delay = i * 0.33;
                      final progress = (loopController.value + delay) % 1.0;
                      final scale = 1.0 + (progress * 0.6);
                      final opacity = (1.0 - progress) * 0.4;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF3B82F6).withOpacity(opacity), width: 2),
                          ),
                        ),
                      );
                    }),
                    Container(
                      width: 160, height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.5), blurRadius: 50, spreadRadius: 15)],
                      ),
                    ),
                    Container(
                      width: 130, height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
                      ),
                      child: const Icon(Icons.mic, size: 60, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('Speak.', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const Text('AI Writes.', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const Text('Done.', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const SizedBox(height: 24),
              Text('Stop typing. Just talk.\nPerfectly written messages in seconds.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400, height: 1.5)),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAGE 2: 20+ PRESETS
// ═══════════════════════════════════════════════════════════════════════════

class _Page2Presets extends StatelessWidget {
  final AnimationController loopController;
  const _Page2Presets({required this.loopController});

  @override
  Widget build(BuildContext context) {
    final presets = [('Email', const Color(0xFF3B82F6)), ('Thread', const Color(0xFF3B82F6)), ('Social', const Color(0xFF3B82F6)), ('Notes', const Color(0xFF3B82F6)), ('Summary', const Color(0xFF3B82F6))];
    return AnimatedBuilder(
      animation: loopController,
      builder: (context, _) {
        final activeIndex = (loopController.value * presets.length * 2).floor() % presets.length;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('20+ Presets', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const SizedBox(height: 16),
              Text('Apply 20+ AI presets to instantly\ndraft emails, threads, or social posts.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400, height: 1.5)),
              const SizedBox(height: 50),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: List.generate(presets.length, (i) {
                  final isActive = i == activeIndex;
                  final preset = presets[i];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    decoration: BoxDecoration(
                      color: isActive ? preset.$2 : preset.$2.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: preset.$2.withOpacity(isActive ? 0.8 : 0.3), width: 2),
                      boxShadow: isActive ? [BoxShadow(color: preset.$2.withOpacity(0.5), blurRadius: 20)] : null,
                    ),
                    child: Text(preset.$1, style: TextStyle(color: Colors.white.withOpacity(isActive ? 1 : 0.7), fontSize: 17, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAGE 3: 50+ LANGUAGES
// ═══════════════════════════════════════════════════════════════════════════

class _Page3Languages extends StatelessWidget {
  final AnimationController loopController;
  const _Page3Languages({required this.loopController});

  @override
  Widget build(BuildContext context) {
    final languages = ['🇺🇸', '🇪🇸', '🇫🇷', '🇩🇪', '🇯🇵', '🇨🇳'];
    return AnimatedBuilder(
      animation: loopController,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('50+ Languages', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const SizedBox(height: 16),
              Text('Speak in yours.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400)),
              const SizedBox(height: 50),
              SizedBox(
                width: 280, height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(3, (i) {
                      final size = 170.0 + (i * 45);
                      return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.12 - (i * 0.03)), width: 1.5)));
                    }),
                    Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.5), blurRadius: 40, spreadRadius: 10)])),
                    ...List.generate(languages.length, (i) {
                      final angle = (i / languages.length) * 2 * math.pi;
                      final rotationAngle = angle + (loopController.value * 2 * math.pi);
                      final x = math.cos(rotationAngle) * 110;
                      final y = math.sin(rotationAngle) * 110;
                      return Transform.translate(
                        offset: Offset(x, y),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))]),
                          alignment: Alignment.center,
                          child: Text(languages[i], style: const TextStyle(fontSize: 22)),
                        ),
                      );
                    }),
                    Container(
                      width: 90, height: 90,
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3B82F6), Color(0xFF2563EB)])),
                      child: const Icon(Icons.mic, size: 44, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAGE 4: ACCESS ANYWHERE
// ═══════════════════════════════════════════════════════════════════════════

class _Page4Anywhere extends StatelessWidget {
  final AnimationController loopController;
  const _Page4Anywhere({required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loopController,
      builder: (context, _) {
        final float = math.sin(loopController.value * math.pi * 2) * 12;
        final pulse = 0.4 + (math.sin(loopController.value * math.pi * 4) * 0.15);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Access', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const Text('Anywhere', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const SizedBox(height: 16),
              Text('Floating bubble for rapid voice access.\nIdea to instant action.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400, height: 1.5)),
              const SizedBox(height: 50),
              Transform.translate(
                offset: Offset(0, float),
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3B82F6), Color(0xFF2563EB)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(pulse), blurRadius: 40, spreadRadius: 10)],
                  ),
                  child: const Icon(Icons.mic_rounded, color: Colors.white, size: 48),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, color: Colors.white.withOpacity(0.6), size: 20),
                    const SizedBox(width: 10),
                    Text('Always one tap away', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAGE 5: THE UNIFIED LIBRARY
// ═══════════════════════════════════════════════════════════════════════════

class _Page5Library extends StatelessWidget {
  final AnimationController loopController;
  const _Page5Library({required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loopController,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('The Unified', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const Text('Library', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const SizedBox(height: 16),
              Text('A single home for your notes,\nimports, and batch projects.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400, height: 1.5)),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(Icons.note_rounded, 'Notes', const Color(0xFF3B82F6), loopController, 0),
                  const SizedBox(width: 16),
                  _buildCard(Icons.download_rounded, 'Imports', const Color(0xFF8B5CF6), loopController, 1),
                  const SizedBox(width: 16),
                  _buildCard(Icons.folder_rounded, 'Projects', const Color(0xFF10B981), loopController, 2),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(IconData icon, String label, Color color, AnimationController loop, int index) {
    final float = math.sin((loop.value * math.pi * 2) + (index * 0.8)) * 6;
    return Transform.translate(
      offset: Offset(0, float),
      child: Container(
        width: 90, height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAGE 7: SHARE FROM ANYWHERE
// ═══════════════════════════════════════════════════════════════════════════

class _Page7Share extends StatelessWidget {
  final AnimationController loopController;
  const _Page7Share({required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loopController,
      builder: (context, _) {
        final float1 = math.sin(loopController.value * math.pi * 2) * 8;
        final float2 = math.sin((loopController.value * math.pi * 2) + 1.5) * 8;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Share from', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const Text('Anywhere', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const SizedBox(height: 16),
              Text('Share PDFs, docs, or images from any app.\nAI processes everything.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.w400, height: 1.5)),
              const SizedBox(height: 40),
              SizedBox(
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5), width: 2),
                        boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.2), blurRadius: 24)],
                      ),
                      child: const Icon(Icons.auto_awesome, color: Color(0xFF3B82F6), size: 36),
                    ),
                    Transform.translate(
                      offset: Offset(-100, float1),
                      child: Container(
                        width: 55, height: 70,
                        decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: const Color(0xFFDC2626).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
                        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 26), Text('PDF', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))]),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(100, float2),
                      child: Container(
                        width: 55, height: 70,
                        decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
                        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.image_rounded, color: Colors.white, size: 26), Text('IMG', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))]),
                      ),
                    ),
                    Transform.translate(offset: const Offset(-50, 0), child: Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.3), size: 20)),
                    Transform.translate(offset: const Offset(50, 0), child: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.3), size: 20)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REFINE & PERFECT
// ═══════════════════════════════════════════════════════════════════════════

class _PageRefine extends StatelessWidget {
  final AnimationController loopController;
  const _PageRefine({required this.loopController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Refine &', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
          const Text('Perfect', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
          const SizedBox(height: 16),
          Text('Highlight to rewrite.\nVoice to refine.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400, height: 1.5)),
          const SizedBox(height: 50),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF3B82F6),
              boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.mic_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text('"Make it more professional"', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.8), size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OUTCOMES
// ═══════════════════════════════════════════════════════════════════════════

class _PageOutcomes extends StatelessWidget {
  const _PageOutcomes();

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ('Call Sarah at 3pm', true),
      ('Send the report', false),
      ('Book flight to NYC', true),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Outcomes', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
          const SizedBox(height: 16),
          Text('AI pulls tasks, reminders\n& actions from your voice.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400, height: 1.5)),
          const SizedBox(height: 50),
          ...tasks.map((task) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF3B82F6),
              boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.25)),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(task.$1, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                if (task.$2)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white.withOpacity(0.2)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.alarm_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('Alarm', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPERS: ANIMATED TEXT WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _AnimatedHeadline extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final String text;
  const _AnimatedHeadline({required this.controller, required this.delay, required this.text});

  @override
  Widget build(BuildContext context) {
    final progress = Curves.easeOut.transform(((controller.value - delay) / 0.15).clamp(0.0, 1.0));
    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - progress)),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1),
          textAlign: TextAlign.center,
        ),
      ),
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
    final progress = Curves.easeOut.transform(((controller.value - delay) / 0.15).clamp(0.0, 1.0));
    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, 15 * (1 - progress)),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w400, height: 1.5),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FINALE: POWER AT YOUR FINGERTIPS
// ═══════════════════════════════════════════════════════════════════════════

class _PageFinale extends StatelessWidget {
  final AnimationController loopController;
  const _PageFinale({required this.loopController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loopController,
      builder: (context, _) {
        final glow = 0.4 + (math.sin(loopController.value * math.pi * 2) * 0.2);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(glow), blurRadius: 50, spreadRadius: 10)]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset('assets/app_logo.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF3B82F6), Color(0xFF2563EB)])), child: const Icon(Icons.mic_rounded, color: Colors.white, size: 56))),
                ),
              ),
              const SizedBox(height: 48),
              const Text('Power at your', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const Text('fingertips.', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1)),
              const SizedBox(height: 20),
              Text('Import. Process. Finish.', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
        );
      },
    );
  }
}
