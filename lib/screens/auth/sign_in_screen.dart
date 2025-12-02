import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class SignInScreen extends StatefulWidget {
  final VoidCallback onSignIn;
  
  const SignInScreen({
    super.key,
    required this.onSignIn,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
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
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement Google Sign In
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isLoading = false);
      widget.onSignIn();
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement Apple Sign In
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isLoading = false);
      widget.onSignIn();
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
            colors: [
              Color(0xFF000000), // Pure black
              Color(0xFF0A0A0A),
              Color(0xFF1A1A1A),
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
                    padding: const EdgeInsets.fromLTRB(32, 80, 32, 24),
                    child: Column(
                      children: [
                        // App Logo - Blue circular mic
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF3B82F6), // Blue
                                Color(0xFF2563EB),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withOpacity(0.5),
                                blurRadius: 50,
                                offset: const Offset(0, 25),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mic,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Title
                        const Text(
                          'Welcome to\nVoiceBubble',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sign in to get started',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 60),
                        
                        // Sign in buttons
                        if (_isLoading)
                          const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        else ...[
                          // Google Sign In
                          _buildSignInButton(
                            onTap: _handleGoogleSignIn,
                            icon: Icons.g_mobiledata_rounded,
                            label: 'Continue with Google',
                            backgroundColor: const Color(0xFF3B82F6), // Blue button
                            textColor: Colors.white,
                            delay: 0,
                          ),
                          const SizedBox(height: 16),
                          
                          // Apple Sign In (iOS only)
                          if (Platform.isIOS) ...[
                            _buildSignInButton(
                              onTap: _handleAppleSignIn,
                              icon: Icons.apple_rounded,
                              label: 'Continue with Apple',
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              delay: 150,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // Terms
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'By signing in, you agree to our Terms of Service and Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
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
    );
  }

  Widget _buildSignInButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: textColor,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    letterSpacing: 0.3,
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
