import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

/// CINEMATIC FEATURE SHOWCASE - THE COMPLETE EXPERIENCE
/// Every killer feature that makes VoiceBubble special
class FeatureShowcaseScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const FeatureShowcaseScreen({super.key, required this.onComplete});

  @override
  State<FeatureShowcaseScreen> createState() => _FeatureShowcaseScreenState();
}

class _FeatureShowcaseScreenState extends State<FeatureShowcaseScreen>
    with TickerProviderStateMixin {

  late AnimationController _backgroundController;
  late AnimationController _contentController;
  late AnimationController _iconController;
  late AnimationController _particleController;
  late AnimationController _demoController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _iconScale;
  late Animation<double> _iconGlow;
  late Animation<Offset> _slideIn;

  int _currentFeature = 0;
  Timer? _autoAdvanceTimer;

  // ALL THE KILLER FEATURES
  final List<_Feature> _features = [
    // 1. Voice to Text
    _Feature(
      icon: Icons.mic_rounded,
      title: 'Speak',
      subtitle: 'Watch It Write',
      tagline: 'Crystal-clear AI transcription in seconds',
      demo: _DemoType.voiceWaves,
      gradient: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    ),

    // 2. AI Presets
    _Feature(
      icon: Icons.auto_awesome_rounded,
      title: 'One Tap',
      subtitle: 'Perfect Output',
      tagline: '10+ AI presets — emails, notes, social & more',
      demo: _DemoType.presetCards,
      gradient: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    ),

    // 3. Custom Instructions
    _Feature(
      icon: Icons.tune_rounded,
      title: 'Your Rules',
      subtitle: 'Your Style',
      tagline: 'Add custom instructions to any preset',
      demo: _DemoType.customInstructions,
      gradient: [Color(0xFF6366F1), Color(0xFF3B82F6)],
    ),

    // 4. Highlight to AI
    _Feature(
      icon: Icons.highlight_rounded,
      title: 'Highlight',
      subtitle: 'Transform',
      tagline: 'Select any text → tap preset → done',
      demo: _DemoType.highlightText,
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    ),

    // 5. Continue with AI Chat
    _Feature(
      icon: Icons.chat_bubble_rounded,
      title: 'Continue',
      subtitle: 'With AI',
      tagline: 'Chat to refine, expand, or change anything',
      demo: _DemoType.aiChat,
      gradient: [Color(0xFF10B981), Color(0xFF06B6D4)],
    ),

    // 6. Full Document Editor
    _Feature(
      icon: Icons.edit_document,
      title: 'Power',
      subtitle: 'Editor',
      tagline: 'Full rich text editing with formatting',
      demo: _DemoType.documentEditor,
      gradient: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    ),

    // 7. Share to App → Instant AI
    _Feature(
      icon: Icons.share_rounded,
      title: 'Share',
      subtitle: 'Instant AI',
      tagline: 'Share anything → tap AI → transformed',
      demo: _DemoType.shareToAI,
      gradient: [Color(0xFFEC4899), Color(0xFFF59E0B)],
    ),

    // 8. Image to Text (OCR)
    _Feature(
      icon: Icons.document_scanner_rounded,
      title: 'Image',
      subtitle: 'To Text',
      tagline: 'OCR extracts text from any image',
      demo: _DemoType.imageToText,
      gradient: [Color(0xFF10B981), Color(0xFF14B8A6)],
    ),

    // 9. Import Anything
    _Feature(
      icon: Icons.folder_copy_rounded,
      title: 'Import',
      subtitle: 'Anything',
      tagline: 'PDFs, Docs, Images, Audio — all supported',
      demo: _DemoType.importFiles,
      gradient: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    ),

    // 10. Upload Audio to AI
    _Feature(
      icon: Icons.audio_file_rounded,
      title: 'Audio',
      subtitle: 'To AI',
      tagline: 'Upload voice memos → transcribe → transform',
      demo: _DemoType.audioUpload,
      gradient: [Color(0xFFF97316), Color(0xFFEF4444)],
    ),

    // 11. Batch Processing
    _Feature(
      icon: Icons.bolt_rounded,
      title: 'Batch',
      subtitle: 'Process',
      tagline: 'Transform 100 files in one go',
      demo: _DemoType.batchProcess,
      gradient: [Color(0xFFEF4444), Color(0xFFF97316)],
    ),

    // 12. Export Anywhere
    _Feature(
      icon: Icons.ios_share_rounded,
      title: 'Export',
      subtitle: 'Anywhere',
      tagline: 'Share, copy, or save in any format',
      demo: _DemoType.exportShare,
      gradient: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    ),

    // 13. Version History
    _Feature(
      icon: Icons.history_rounded,
      title: 'Version',
      subtitle: 'Restore',
      tagline: 'Every edit saved — restore anytime',
      demo: _DemoType.versionHistory,
      gradient: [Color(0xFF64748B), Color(0xFF475569)],
    ),

    // 14. Tasks & Scheduling
    _Feature(
      icon: Icons.task_alt_rounded,
      title: 'Tasks',
      subtitle: 'Schedule',
      tagline: 'Create tasks & schedule content',
      demo: _DemoType.tasksSchedule,
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
    ),

    // 15. Ready - CTA
    _Feature(
      icon: Icons.rocket_launch_rounded,
      title: 'Ready?',
      subtitle: "Let's Go",
      tagline: 'Your voice, transformed',
      demo: _DemoType.rocket,
      gradient: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startFeature();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0.15, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _iconScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _iconGlow = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _demoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
  }

  void _startFeature() {
    _contentController.forward(from: 0);

    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted && _currentFeature < _features.length - 1) {
        _nextFeature();
      }
    });
  }

  void _nextFeature() {
    if (_currentFeature < _features.length - 1) {
      HapticFeedback.lightImpact();
      _contentController.reverse().then((_) {
        setState(() => _currentFeature++);
        _startFeature();
      });
    }
  }

  void _previousFeature() {
    if (_currentFeature > 0) {
      HapticFeedback.lightImpact();
      _contentController.reverse().then((_) {
        setState(() => _currentFeature--);
        _startFeature();
      });
    }
  }

  void _goToFeature(int index) {
    if (index != _currentFeature) {
      _autoAdvanceTimer?.cancel();
      HapticFeedback.lightImpact();
      _contentController.reverse().then((_) {
        setState(() => _currentFeature = index);
        _startFeature();
      });
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _backgroundController.dispose();
    _contentController.dispose();
    _iconController.dispose();
    _particleController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feature = _features[_currentFeature];
    final isLastFeature = _currentFeature == _features.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          _autoAdvanceTimer?.cancel();
          if (details.primaryVelocity! < -300) {
            _nextFeature();
          } else if (details.primaryVelocity! > 300) {
            _previousFeature();
          }
        },
        child: Stack(
          children: [
            _buildBackground(feature),
            _buildParticles(feature),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SlideTransition(
                      position: _slideIn,
                      child: FadeTransition(
                        opacity: _contentController,
                        child: _buildContent(feature),
                      ),
                    ),
                  ),
                  _buildProgress(),
                  _buildCTA(isLastFeature, feature),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(_Feature feature) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                math.sin(_backgroundAnimation.value * math.pi) * 0.5,
                -0.3 + math.cos(_backgroundAnimation.value * math.pi) * 0.2,
              ),
              radius: 1.5,
              colors: [
                feature.gradient[0].withOpacity(0.35),
                feature.gradient[1].withOpacity(0.15),
                Colors.black,
              ],
              stops: const [0.0, 0.35, 0.7],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles(_Feature feature) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            progress: _particleController.value,
            color: feature.gradient[0],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'VoiceBubble',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: widget.onComplete,
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(_Feature feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedIcon(feature),
          const SizedBox(height: 32),
          _buildTitle(feature),
          const SizedBox(height: 14),
          _buildTagline(feature),
          const SizedBox(height: 32),
          _buildDemo(feature),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(_Feature feature) {
    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: feature.gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: feature.gradient[0].withOpacity(0.5 * _iconGlow.value),
                blurRadius: 40 * _iconGlow.value,
                spreadRadius: 8 * _iconGlow.value,
              ),
            ],
          ),
          child: Transform.scale(
            scale: _iconScale.value,
            child: Icon(feature.icon, color: Colors.white, size: 46),
          ),
        );
      },
    );
  }

  Widget _buildTitle(_Feature feature) {
    return Column(
      children: [
        Text(
          feature.title,
          style: const TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -1.5,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: feature.gradient,
          ).createShader(bounds),
          child: Text(
            feature.subtitle,
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.5,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagline(_Feature feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: feature.gradient[0].withOpacity(0.25),
        ),
      ),
      child: Text(
        feature.tagline,
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDemo(_Feature feature) {
    return AnimatedBuilder(
      animation: _demoController,
      builder: (context, _) {
        return SizedBox(
          height: 80,
          child: _buildDemoContent(feature),
        );
      },
    );
  }

  Widget _buildDemoContent(_Feature feature) {
    switch (feature.demo) {
      case _DemoType.voiceWaves:
        return _buildVoiceWavesDemo(feature);
      case _DemoType.presetCards:
        return _buildPresetCardsDemo(feature);
      case _DemoType.highlightText:
        return _buildHighlightDemo(feature);
      case _DemoType.imageToText:
        return _buildImageToTextDemo(feature);
      case _DemoType.importFiles:
        return _buildImportFilesDemo(feature);
      case _DemoType.batchProcess:
        return _buildBatchDemo(feature);
      case _DemoType.customInstructions:
        return _buildCustomInstructionsDemo(feature);
      case _DemoType.rocket:
        return _buildRocketDemo(feature);
      case _DemoType.aiChat:
        return _buildAIChatDemo(feature);
      case _DemoType.documentEditor:
        return _buildDocumentEditorDemo(feature);
      case _DemoType.shareToAI:
        return _buildShareToAIDemo(feature);
      case _DemoType.audioUpload:
        return _buildAudioUploadDemo(feature);
      case _DemoType.exportShare:
        return _buildExportShareDemo(feature);
      case _DemoType.versionHistory:
        return _buildVersionHistoryDemo(feature);
      case _DemoType.tasksSchedule:
        return _buildTasksScheduleDemo(feature);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DEMO ANIMATIONS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildVoiceWavesDemo(_Feature feature) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(14, (index) {
        final delay = index * 0.07;
        final height = 15 +
            math.sin((_demoController.value * 2 * math.pi) + delay * math.pi * 2) * 25;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: 4,
          height: height.abs() + 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: feature.gradient,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPresetCardsDemo(_Feature feature) {
    final presets = ['Email', 'Notes', 'Social', 'Recipe'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(presets.length, (index) {
        final isActive = ((_demoController.value * 4).floor() % 4) == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? feature.gradient[0] : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            presets[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHighlightDemo(_Feature feature) {
    final progress = _demoController.value;
    final highlightWidth = progress < 0.5 ? progress * 2 : 1.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Text(
              'Transform this text',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16),
            ),
            ClipRect(
              clipper: _TextClipper(highlightWidth),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: feature.gradient[0].withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Transform this text',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        if (progress > 0.6)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, color: feature.gradient[0], size: 14),
                const SizedBox(width: 5),
                Text('AI Rewriting...', style: TextStyle(color: feature.gradient[0], fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAIChatDemo(_Feature feature) {
    final progress = _demoController.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // User message
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: feature.gradient[0],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Make it longer', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // AI response
        if (progress > 0.3)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: feature.gradient[1], size: 14),
                    const SizedBox(width: 6),
                    Text(
                      progress > 0.6 ? 'Done! Expanded to 3 paragraphs' : 'Expanding...',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDocumentEditorDemo(_Feature feature) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: feature.gradient[0].withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              _buildFormatButton(Icons.format_bold, feature),
              _buildFormatButton(Icons.format_italic, feature),
              _buildFormatButton(Icons.format_list_bulleted, feature),
              _buildFormatButton(Icons.image, feature),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 100 + (_demoController.value * 60),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, _Feature feature) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: feature.gradient[0], size: 16),
    );
  }

  Widget _buildShareToAIDemo(_Feature feature) {
    final progress = _demoController.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.share, color: Colors.white.withOpacity(0.6), size: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: List.generate(3, (i) {
              final opacity = ((progress * 3 - i) % 1.0).clamp(0.0, 1.0);
              return Icon(Icons.chevron_right, color: feature.gradient[0].withOpacity(opacity), size: 20);
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: feature.gradient),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
        ),
        if (progress > 0.7)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(Icons.check_circle, color: feature.gradient[1], size: 28),
          ),
      ],
    );
  }

  Widget _buildImageToTextDemo(_Feature feature) {
    final progress = _demoController.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.image, color: feature.gradient[0], size: 28),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: List.generate(3, (i) {
              final opacity = ((progress * 3 - i) % 1.0).clamp(0.0, 1.0);
              return Icon(Icons.chevron_right, color: feature.gradient[0].withOpacity(opacity), size: 20);
            }),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.text_fields, color: feature.gradient[1], size: 28),
        ),
      ],
    );
  }

  Widget _buildImportFilesDemo(_Feature feature) {
    final icons = [Icons.picture_as_pdf, Icons.description, Icons.image, Icons.audiotrack];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(icons.length, (index) {
        final delay = index * 0.15;
        final bounce = math.sin((_demoController.value + delay) * math.pi * 2) * 6;

        return Transform.translate(
          offset: Offset(0, bounce),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: feature.gradient[index % 2].withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icons[index], color: Colors.white, size: 20),
          ),
        );
      }),
    );
  }

  Widget _buildAudioUploadDemo(_Feature feature) {
    final progress = _demoController.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.audio_file, color: feature.gradient[0], size: 32),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(feature.gradient[0]),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (progress > 0.8)
          Icon(Icons.text_snippet, color: feature.gradient[1], size: 32),
      ],
    );
  }

  Widget _buildBatchDemo(_Feature feature) {
    final count = ((_demoController.value * 100) % 100).floor();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$count / 100',
          style: TextStyle(color: feature.gradient[0], fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: _demoController.value,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(feature.gradient[0]),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExportShareDemo(_Feature feature) {
    final icons = [Icons.copy, Icons.share, Icons.save_alt, Icons.email];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(icons.length, (index) {
        final isActive = ((_demoController.value * 4).floor() % 4) == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? feature.gradient[0] : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icons[index], color: Colors.white, size: 20),
        );
      }),
    );
  }

  Widget _buildVersionHistoryDemo(_Feature feature) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildVersionDot('v1', feature, 0.3),
        _buildVersionLine(feature),
        _buildVersionDot('v2', feature, 0.6),
        _buildVersionLine(feature),
        _buildVersionDot('v3', feature, 1.0),
      ],
    );
  }

  Widget _buildVersionDot(String label, _Feature feature, double targetProgress) {
    final isActive = _demoController.value >= targetProgress;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? feature.gradient[0] : Colors.white.withOpacity(0.1),
          ),
          child: Center(
            child: isActive
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10)),
      ],
    );
  }

  Widget _buildVersionLine(_Feature feature) {
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: feature.gradient[0].withOpacity(0.3),
    );
  }

  Widget _buildTasksScheduleDemo(_Feature feature) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: feature.gradient[0], size: 18),
              const SizedBox(width: 6),
              const Text('Send report', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: feature.gradient[0].withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule, color: feature.gradient[1], size: 18),
              const SizedBox(width: 6),
              const Text('2:00 PM', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomInstructionsDemo(_Feature feature) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: feature.gradient[0].withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit_note, color: feature.gradient[0], size: 20),
          const SizedBox(width: 10),
          Text(
            '"Make it professional & concise"',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildRocketDemo(_Feature feature) {
    final bounce = math.sin(_demoController.value * math.pi * 4) * 8;

    return Transform.translate(
      offset: Offset(0, -bounce.abs()),
      child: Icon(Icons.rocket_launch_rounded, color: feature.gradient[0], size: 56),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_features.length, (index) {
          final isActive = index == _currentFeature;
          final isPast = index < _currentFeature;

          return GestureDetector(
            onTap: () => _goToFeature(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: isActive || isPast
                    ? _features[index].gradient[0]
                    : Colors.white.withOpacity(0.2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCTA(bool isLastFeature, _Feature feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLastFeature ? widget.onComplete : () {
            _autoAdvanceTimer?.cancel();
            _nextFeature();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: feature.gradient),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastFeature ? 'Get Started' : 'Next',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isLastFeature ? Icons.arrow_forward_rounded : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MODELS & PAINTERS
// ═══════════════════════════════════════════════════════════════

enum _DemoType {
  voiceWaves,
  presetCards,
  highlightText,
  imageToText,
  importFiles,
  batchProcess,
  customInstructions,
  rocket,
  aiChat,
  documentEditor,
  shareToAI,
  audioUpload,
  exportShare,
  versionHistory,
  tasksSchedule,
}

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  final String tagline;
  final _DemoType demo;
  final List<Color> gradient;

  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tagline,
    required this.demo,
    required this.gradient,
  });
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ParticlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 0.3 + random.nextDouble() * 0.4;
      final y = (baseY - (progress * size.height * speed)) % size.height;
      final radius = 1.5 + random.nextDouble() * 3;
      final opacity = 0.08 + random.nextDouble() * 0.15;

      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _TextClipper extends CustomClipper<Rect> {
  final double progress;
  _TextClipper(this.progress);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * progress, size.height);

  @override
  bool shouldReclip(covariant _TextClipper oldClipper) => oldClipper.progress != progress;
}
