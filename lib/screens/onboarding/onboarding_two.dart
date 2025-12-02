import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingTwo extends StatefulWidget {
  final VoidCallback onNext;
  
  const OnboardingTwo({super.key, required this.onNext});

  @override
  State<OnboardingTwo> createState() => _OnboardingTwoState();
}

class _OnboardingTwoState extends State<OnboardingTwo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bubbleController;
  late AnimationController _globeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
    
    _globeController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bubbleController.dispose();
    _globeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1), // Darker blue
              Color(0xFF1565C0),
              Color(0xFF1E88E5), // Logo blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(32, 60, 32, 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Title
                        const Text(
                          'Access Anywhere',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Floating bubble for rapid voice access',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 60),
                        // Floating Bubble Animation
                        _buildFloatingBubbleDemo(),
                        const SizedBox(height: 50),
                        // Feature Cards
                        _buildFeatureCard(
                          icon: Icons.bolt_rounded,
                          title: 'Works Over Any App',
                          subtitle: 'WhatsApp, Gmail, Instagram, anywhere you type',
                          delay: 0,
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureCard(
                          icon: Icons.language_rounded,
                          title: '30+ Languages',
                          subtitle: 'English, Spanish, French, German, Japanese, and more',
                          delay: 200,
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureCard(
                          icon: Icons.speed_rounded,
                          title: 'Lightning Fast',
                          subtitle: 'Tap bubble → speak → done in seconds',
                          delay: 400,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              // Button
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0D47A1),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
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
    );
  }

  Widget _buildFloatingBubbleDemo() {
    return AnimatedBuilder(
      animation: _bubbleController,
      builder: (context, child) {
        final floatOffset = math.sin(_bubbleController.value * 2 * math.pi) * 15;
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing background circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              // Main bubble
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF42A5F5),
                      Color(0xFF1E88E5),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E88E5).withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              // Orbiting language icons
              ..._buildOrbitingLanguages(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildOrbitingLanguages() {
    final languages = ['🇺🇸', '🇪🇸', '🇫🇷', '🇩🇪', '🇯🇵', '🇨🇳'];
    return List.generate(languages.length, (index) {
      final angle = (index / languages.length) * 2 * math.pi;
      return AnimatedBuilder(
        animation: _globeController,
        builder: (context, child) {
          final rotationAngle = angle + (_globeController.value * 2 * math.pi);
          final x = math.cos(rotationAngle) * 110;
          final y = math.sin(rotationAngle) * 110;
          return Transform.translate(
            offset: Offset(x, y),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                languages[index],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 28,
                color: const Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
