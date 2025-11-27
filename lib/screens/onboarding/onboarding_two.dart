import 'package:flutter/material.dart';
import '../../widgets/gradient_background.dart';

class OnboardingTwo extends StatelessWidget {
  final VoidCallback onNext;
  
  const OnboardingTwo({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return BlueCyanGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(32, 48, 32, 24),
                  child: Column(
                    children: [
                      // Icon
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(96),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_fix_high,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Title
                      const Text(
                        'Choose Your Style',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Description
                      const Text(
                        'Record your voice, then pick how you want it written. Email? Message? Post? We got you.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFBAE6FD),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Example Cards
                      _buildExampleCard(
                        '📧 Professional Email',
                        'I apologize for the delay. I will arrive shortly.',
                      ),
                      const SizedBox(height: 12),
                      _buildExampleCard(
                        '💬 Casual Message',
                        'Hey! Running late, be there soon',
                      ),
                      const SizedBox(height: 12),
                      _buildExampleCard(
                        '📝 To-Do List',
                        '• Finish report\n• Arrive at meeting',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Fixed button at bottom
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E3A8A),
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
                        fontWeight: FontWeight.w600,
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
  
  Widget _buildExampleCard(String label, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFBAE6FD),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

