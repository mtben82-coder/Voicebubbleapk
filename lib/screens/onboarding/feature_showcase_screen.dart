import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Cinematic feature showcase screen for onboarding.
/// Displays 15 features with auto-advancing pages and smooth animations.
class FeatureShowcaseScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const FeatureShowcaseScreen({super.key, required this.onComplete});

  @override
  State<FeatureShowcaseScreen> createState() => _FeatureShowcaseScreenState();
}

class _FeatureShowcaseScreenState extends State<FeatureShowcaseScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  static const _features = <_Feature>[
    _Feature(
      icon: Icons.mic_rounded,
      title: 'Voice-to-Text',
      subtitle: 'Speak naturally and watch your words appear as polished text instantly',
      color: Color(0xFF3B82F6),
    ),
    _Feature(
      icon: Icons.auto_awesome_rounded,
      title: 'AI Rewriting',
      subtitle: 'Your raw speech is refined into clear, professional writing automatically',
      color: Color(0xFF8B5CF6),
    ),
    _Feature(
      icon: Icons.bubble_chart_rounded,
      title: 'Floating Bubble',
      subtitle: 'Access VoiceBubble from any app with the always-on floating overlay',
      color: Color(0xFF06B6D4),
    ),
    _Feature(
      icon: Icons.language_rounded,
      title: '30+ Languages',
      subtitle: 'Speak in English, Spanish, French, German, Japanese, and many more',
      color: Color(0xFF10B981),
    ),
    _Feature(
      icon: Icons.palette_rounded,
      title: '30+ AI Presets',
      subtitle: 'Professional email, casual chat, poetry, social media captions, and more',
      color: Color(0xFFF59E0B),
    ),
    _Feature(
      icon: Icons.bolt_rounded,
      title: 'Lightning Fast',
      subtitle: 'Tap the bubble, speak for a few seconds, and your text is ready to paste',
      color: Color(0xFFEF4444),
    ),
    _Feature(
      icon: Icons.content_copy_rounded,
      title: 'One-Tap Copy',
      subtitle: 'Copy your polished text to clipboard with a single tap',
      color: Color(0xFF3B82F6),
    ),
    _Feature(
      icon: Icons.share_rounded,
      title: 'Share Anywhere',
      subtitle: 'Send your text directly to WhatsApp, Gmail, Instagram, or any app',
      color: Color(0xFF8B5CF6),
    ),
    _Feature(
      icon: Icons.history_rounded,
      title: 'History & Search',
      subtitle: 'All your voice notes are saved and searchable so nothing is lost',
      color: Color(0xFF06B6D4),
    ),
    _Feature(
      icon: Icons.folder_rounded,
      title: 'Smart Folders',
      subtitle: 'Organize your recordings into custom folders for easy access',
      color: Color(0xFF10B981),
    ),
    _Feature(
      icon: Icons.edit_note_rounded,
      title: 'Edit & Refine',
      subtitle: 'Fine-tune your AI-generated text before sharing or copying',
      color: Color(0xFFF59E0B),
    ),
    _Feature(
      icon: Icons.notifications_active_rounded,
      title: 'Smart Reminders',
      subtitle: 'Set reminders on your voice notes so you never forget to follow up',
      color: Color(0xFFEF4444),
    ),
    _Feature(
      icon: Icons.dark_mode_rounded,
      title: 'Dark Mode',
      subtitle: 'Beautiful dark interface that is easy on your eyes day and night',
      color: Color(0xFF3B82F6),
    ),
    _Feature(
      icon: Icons.import_export_rounded,
      title: 'Import & Export',
      subtitle: 'Receive shared audio, text, and files from other apps seamlessly',
      color: Color(0xFF8B5CF6),
    ),
    _Feature(
      icon: Icons.security_rounded,
      title: 'Private & Secure',
      subtitle: 'Your voice recordings and text stay on your device, always private',
      color: Color(0xFF10B981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _features.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header with progress
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_currentPage + 1} / ${_features.length}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          if (!isLastPage)
                            GestureDetector(
                              onTap: widget.onComplete,
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_currentPage + 1) / _features.length,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _features[_currentPage].color,
                          ),
                          minHeight: 3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _features.length,
                    itemBuilder: (context, index) {
                      return _FeaturePage(
                        feature: _features[index],
                        index: index,
                        pulseController: _pulseController,
                      );
                    },
                  ),
                ),

                // Dot indicators
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_features.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: isActive
                              ? _features[_currentPage].color
                              : Colors.white.withOpacity(0.2),
                        ),
                      );
                    }),
                  ),
                ),

                // Bottom button
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLastPage
                          ? widget.onComplete
                          : () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _features[_currentPage].color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isLastPage ? 'Continue' : 'Next Feature',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
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

/// Individual feature page shown inside the PageView.
class _FeaturePage extends StatelessWidget {
  final _Feature feature;
  final int index;
  final AnimationController pulseController;

  const _FeaturePage({
    required this.feature,
    required this.index,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final scale = 1.0 + 0.08 * math.sin(pulseController.value * math.pi);
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    feature.color,
                    feature.color.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: feature.color.withOpacity(0.4),
                    blurRadius: 50,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Icon(
                feature.icon,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Title
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            feature.subtitle,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Decorative accent line
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for a single feature entry.
class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
