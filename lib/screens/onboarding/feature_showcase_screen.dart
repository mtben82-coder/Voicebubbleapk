import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

/// ═══════════════════════════════════════════════════════════════════════════
/// ELITE CINEMATIC FEATURE SHOWCASE
/// ═══════════════════════════════════════════════════════════════════════════
/// 
/// A masterpiece onboarding experience. 5 pages, 3 features each.
/// Staggered reveals. Breathing backgrounds. Glowing icons. Pure cinema.
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
  
  // ═══════════════════════════════════════════════════════════════
  // ANIMATION CONTROLLERS
  // ═══════════════════════════════════════════════════════════════
  
  late AnimationController _backgroundController;
  late AnimationController _feature1Controller;
  late AnimationController _feature2Controller;
  late AnimationController _feature3Controller;
  late AnimationController _glowController;
  late AnimationController _particleController;
  
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  // ═══════════════════════════════════════════════════════════════
  // PAGE DATA - 5 PAGES, 3 FEATURES EACH
  // ═══════════════════════════════════════════════════════════════

  final List<_PageData> _pages = [
    // PAGE 1: CAPTURE
    _PageData(
      title: 'Capture',
      subtitle: 'Everything',
      gradient: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
      features: [
        _FeatureData(
          icon: Icons.mic_rounded,
          title: 'Voice to Text',
          subtitle: 'Speak naturally, watch it write',
        ),
        _FeatureData(
          icon: Icons.document_scanner_rounded,
          title: 'Image to Text',
          subtitle: 'OCR extracts text instantly',
        ),
        _FeatureData(
          icon: Icons.folder_rounded,
          title: 'Import Anything',
          subtitle: 'PDFs, Docs, Audio — all supported',
        ),
      ],
    ),
    
    // PAGE 2: TRANSFORM
    _PageData(
      title: 'Transform',
      subtitle: 'Instantly',
      gradient: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
      features: [
        _FeatureData(
          icon: Icons.auto_awesome_rounded,
          title: 'AI Presets',
          subtitle: 'One tap, perfect output',
        ),
        _FeatureData(
          icon: Icons.tune_rounded,
          title: 'Custom Instructions',
          subtitle: 'Your rules, your style',
        ),
        _FeatureData(
          icon: Icons.highlight_rounded,
          title: 'Highlight to AI',
          subtitle: 'Select text, transform instantly',
        ),
      ],
    ),
    
    // PAGE 3: REFINE
    _PageData(
      title: 'Refine',
      subtitle: 'Perfectly',
      gradient: [Color(0xFF10B981), Color(0xFF06B6D4)],
      features: [
        _FeatureData(
          icon: Icons.chat_rounded,
          title: 'Continue with AI',
          subtitle: 'Chat to expand or refine',
        ),
        _FeatureData(
          icon: Icons.edit_document,
          title: 'Power Editor',
          subtitle: 'Full rich text formatting',
        ),
        _FeatureData(
          icon: Icons.history_rounded,
          title: 'Version History',
          subtitle: 'Restore any previous edit',
        ),
      ],
    ),
    
    // PAGE 4: POWER
    _PageData(
      title: 'Power',
      subtitle: 'Unleashed',
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      features: [
        _FeatureData(
          icon: Icons.bubble_chart_rounded,
          title: 'Floating Bubble',
          subtitle: 'Access anywhere on your phone',
        ),
        _FeatureData(
          icon: Icons.bolt_rounded,
          title: 'Batch Processing',
          subtitle: 'Transform 100 files at once',
        ),
        _FeatureData(
          icon: Icons.ios_share_rounded,
          title: 'Export & Share',
          subtitle: 'Send anywhere, any format',
        ),
      ],
    ),
    
    // PAGE 5: READY
    _PageData(
      title: "Let's",
      subtitle: 'Go',
      gradient: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
      features: [],
      isLastPage: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startPageAnimations();
  }

  void _initAnimations() {
    // Background gradient breathing
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Staggered feature animations
    _feature1Controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _feature2Controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _feature3Controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Icon glow pulse
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Floating particles
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    )..repeat();
  }

  void _startPageAnimations() {
    // Reset all feature animations
    _feature1Controller.reset();
    _feature2Controller.reset();
    _feature3Controller.reset();
    
    // Staggered reveal - each feature appears 300ms after the previous
    _feature1Controller.forward();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _feature2Controller.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _feature3Controller.forward();
    });
    
    // Auto-advance after 4 seconds (skip on last page)
    _autoAdvanceTimer?.cancel();
    if (_currentPage < _pages.length - 1) {
      _autoAdvanceTimer = Timer(const Duration(milliseconds: 4000), () {
        if (mounted) _nextPage();
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      HapticFeedback.lightImpact();
      setState(() => _currentPage++);
      _startPageAnimations();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      setState(() => _currentPage--);
      _startPageAnimations();
    }
  }

  void _goToPage(int index) {
    if (index != _currentPage && index >= 0 && index < _pages.length) {
      _autoAdvanceTimer?.cancel();
      HapticFeedback.lightImpact();
      setState(() => _currentPage = index);
      _startPageAnimations();
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _backgroundController.dispose();
    _feature1Controller.dispose();
    _feature2Controller.dispose();
    _feature3Controller.dispose();
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          _autoAdvanceTimer?.cancel();
          if (details.primaryVelocity! < -300) {
            _nextPage();
          } else if (details.primaryVelocity! > 300) {
            _previousPage();
          }
        },
        child: Stack(
          children: [
            // Layer 1: Animated gradient background
            _buildBackground(page),
            
            // Layer 2: Floating particles
            _buildParticles(page),
            
            // Layer 3: Radial glow behind content
            _buildRadialGlow(page),
            
            // Layer 4: Main content
            SafeArea(
              child: Column(
                children: [
                  // Header with skip button
                  _buildHeader(),
                  
                  // Main content area
                  Expanded(
                    child: page.isLastPage 
                        ? _buildLastPage(page)
                        : _buildFeaturePage(page),
                  ),
                  
                  // Progress dots
                  _buildProgressDots(),
                  
                  // CTA Button
                  _buildCTAButton(page),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BACKGROUND LAYERS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBackground(_PageData page) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, _) {
        final breathe = math.sin(_backgroundController.value * math.pi) * 0.15;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.5 + breathe),
              radius: 1.8,
              colors: [
                page.gradient[0].withOpacity(0.35 + breathe * 0.5),
                page.gradient[1].withOpacity(0.15),
                Colors.black,
                Colors.black,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles(_PageData page) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _EliteParticlePainter(
            progress: _particleController.value,
            color: page.gradient[0],
          ),
        );
      },
    );
  }

  Widget _buildRadialGlow(_PageData page) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, _) {
        final intensity = 0.1 + _glowController.value * 0.1;
        
        return Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  page.gradient[0].withOpacity(intensity),
                  page.gradient[0].withOpacity(0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'VoiceBubble',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          // Skip button
          TextButton(
            onPressed: widget.onComplete,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // FEATURE PAGE (Pages 1-4)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildFeaturePage(_PageData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          
          // Page title
          _buildPageTitle(page),
          
          const SizedBox(height: 48),
          
          // 3 Features with staggered animation
          _buildFeatureCard(page.features[0], _feature1Controller, page),
          const SizedBox(height: 16),
          _buildFeatureCard(page.features[1], _feature2Controller, page),
          const SizedBox(height: 16),
          _buildFeatureCard(page.features[2], _feature3Controller, page),
          
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildPageTitle(_PageData page) {
    return Column(
      children: [
        // Main title
        Text(
          page.title,
          style: const TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -2,
            height: 1.0,
          ),
        ),
        // Gradient subtitle
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: page.gradient,
          ).createShader(bounds),
          child: Text(
            page.subtitle,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -2,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(_FeatureData feature, AnimationController controller, _PageData page) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final slideValue = Curves.easeOutCubic.transform(controller.value);
        final fadeValue = Curves.easeOut.transform(controller.value);
        
        return Transform.translate(
          offset: Offset(0, 30 * (1 - slideValue)),
          child: Opacity(
            opacity: fadeValue,
            child: child,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, _) {
          final glowIntensity = 0.1 + _glowController.value * 0.15;
          
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: page.gradient[0].withOpacity(0.2 + _glowController.value * 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: page.gradient[0].withOpacity(glowIntensity * 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Glowing icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: page.gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: page.gradient[0].withOpacity(glowIntensity),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    feature.icon,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feature.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LAST PAGE (Page 5 - CTA)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildLastPage(_PageData page) {
    return AnimatedBuilder(
      animation: _feature1Controller,
      builder: (context, _) {
        final scale = 0.8 + (0.2 * _feature1Controller.value);
        final opacity = _feature1Controller.value;
        
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated rocket icon with glow
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, _) {
                    final bounce = math.sin(_glowController.value * math.pi * 2) * 8;
                    final glowIntensity = 0.4 + _glowController.value * 0.4;
                    
                    return Transform.translate(
                      offset: Offset(0, -bounce),
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: page.gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: page.gradient[0].withOpacity(glowIntensity),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: page.gradient[1].withOpacity(glowIntensity * 0.5),
                              blurRadius: 80,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 48),
                
                // Title
                const Text(
                  "Let's",
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -2,
                    height: 1.0,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: page.gradient,
                  ).createShader(bounds),
                  child: const Text(
                    'Go',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -2,
                      height: 1.1,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Tagline
                Text(
                  'Your voice, transformed',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PROGRESS DOTS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildProgressDots() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_pages.length, (index) {
          final isActive = index == _currentPage;
          final isPast = index < _currentPage;
          
          return GestureDetector(
            onTap: () => _goToPage(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: isActive ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: (isActive || isPast)
                    ? LinearGradient(colors: _pages[index].gradient)
                    : null,
                color: (isActive || isPast) ? null : Colors.white.withOpacity(0.2),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: _pages[index].gradient[0].withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CTA BUTTON
  // ═══════════════════════════════════════════════════════════════

  Widget _buildCTAButton(_PageData page) {
    final isLastPage = page.isLastPage;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, _) {
          final glowIntensity = 0.3 + _glowController.value * 0.2;
          
          return Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: page.gradient),
              boxShadow: [
                BoxShadow(
                  color: page.gradient[0].withOpacity(glowIntensity),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLastPage ? widget.onComplete : () {
                  _autoAdvanceTimer?.cancel();
                  _nextPage();
                },
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastPage ? 'Get Started' : 'Continue',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isLastPage 
                            ? Icons.arrow_forward_rounded 
                            : Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: isLastPage ? 22 : 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

class _PageData {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final List<_FeatureData> features;
  final bool isLastPage;

  const _PageData({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.features,
    this.isLastPage = false,
  });
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// ELITE PARTICLE PAINTER
// ═══════════════════════════════════════════════════════════════════════════

class _EliteParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  _EliteParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = math.Random(42);

    // Floating orbs - larger, more visible
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 0.2 + random.nextDouble() * 0.3;
      final y = (baseY - (progress * size.height * speed * 0.5)) % size.height;
      final radius = 3 + random.nextDouble() * 6;
      final opacity = 0.15 + random.nextDouble() * 0.2;

      paint.color = color.withOpacity(opacity);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Tiny sparkles
    paint.maskFilter = null;
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final twinkle = math.sin((progress * 4 + i * 0.5) * math.pi);
      
      if (twinkle > 0.3) {
        final radius = 1 + twinkle * 2;
        final opacity = twinkle * 0.4;
        paint.color = Colors.white.withOpacity(opacity);
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EliteParticlePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
