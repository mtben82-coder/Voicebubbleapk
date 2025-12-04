import 'package:flutter/material.dart';
import 'dart:math' as math;

class PaywallScreen extends StatefulWidget {
  final VoidCallback onSubscribe;
  final VoidCallback onRestore;
  final VoidCallback onClose;
  
  const PaywallScreen({
    super.key,
    required this.onSubscribe,
    required this.onRestore,
    required this.onClose,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  String _selectedPlan = 'yearly'; // 'monthly' or 'yearly'

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D47A1),
              const Color(0xFF1565C0),
              const Color(0xFF1E88E5).withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
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
                            // Premium Badge
                            _buildShimmeringBadge(),
                            const SizedBox(height: 32),
                            // Title
                            const Text(
                              'Unlock Premium',
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
                              'Get unlimited access to all features',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 50),
                            // Features
                            _buildFeature(
                              icon: Icons.timer_rounded,
                              title: '90 Minutes Speech-to-Text',
                              subtitle: '90 minutes of high-quality voice transcription',
                              delay: 0,
                            ),
                            const SizedBox(height: 16),
                            _buildFeature(
                              icon: Icons.auto_awesome_rounded,
                              title: 'Premium AI Models',
                              subtitle: 'Access to GPT-4 for higher quality rewrites',
                              delay: 100,
                            ),
                            const SizedBox(height: 16),
                            _buildFeature(
                              icon: Icons.palette_rounded,
                              title: 'Custom Presets',
                              subtitle: 'Create unlimited personalized writing styles',
                              delay: 200,
                            ),
                            const SizedBox(height: 16),
                            _buildFeature(
                              icon: Icons.cloud_sync_rounded,
                              title: 'Cloud Sync',
                              subtitle: 'Sync your presets across all devices',
                              delay: 300,
                            ),
                            const SizedBox(height: 16),
                            _buildFeature(
                              icon: Icons.workspace_premium_rounded,
                              title: 'Priority Support',
                              subtitle: 'Get help faster with premium support',
                              delay: 400,
                            ),
                            const SizedBox(height: 50),
                            // Plan Selection
                            _buildPlanSelector(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Subscribe Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                    child: Column(
                      children: [
                        // Continue with Free Trial (Skip Paywall)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onClose,
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
                              'Continue with 1-Day Free Trial',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Subscribe Now (actual payment)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: widget.onSubscribe,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              'Subscribe Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: widget.onRestore,
                          child: Text(
                            'Restore Purchase',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Free for 1 day, then ${_selectedPlan == 'yearly' ? '\$49.99/year' : '\$5.99/month'}. Cancel anytime.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Close button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmeringBadge() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber.shade300,
                Colors.amber.shade200,
                Colors.amber.shade300,
              ],
              stops: [
                0.0,
                _shimmerController.value,
                1.0,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xFF0D47A1),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'PREMIUM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0D47A1),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeature({
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
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 26,
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
                      fontSize: 16,
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
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.greenAccent,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSelector() {
    return Column(
      children: [
        Text(
          'Choose Your Plan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPlanCard(
                title: 'Monthly',
                price: '\$5.99',
                period: 'per month',
                value: 'monthly',
                savings: null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPlanCard(
                title: 'Yearly',
                price: '\$49.99',
                period: 'per year',
                value: 'yearly',
                savings: 'Save 30%',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String period,
    required String value,
    String? savings,
  }) {
    final isSelected = _selectedPlan == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Column(
          children: [
            if (savings != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  savings,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              period,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? const Color(0xFF0D47A1).withOpacity(0.7)
                    : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

