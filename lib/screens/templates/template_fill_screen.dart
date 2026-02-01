// ============================================================
//        ELITE TEMPLATE FILL SCREEN
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'template_models.dart';
// import '../services/ai_service.dart'; // Your AI service for generating output

class TemplateFillScreen extends StatefulWidget {
  final AppTemplate template;

  const TemplateFillScreen({super.key, required this.template});

  @override
  State<TemplateFillScreen> createState() => _TemplateFillScreenState();
}

class _TemplateFillScreenState extends State<TemplateFillScreen> with TickerProviderStateMixin {
  late FilledTemplate _filledTemplate;
  int _currentSectionIndex = 0;
  bool _isRecording = false;
  bool _isGenerating = false;
  String? _generatedOutput;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _filledTemplate = FilledTemplate(templateId: widget.template.id);
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  TemplateSection get _currentSection => widget.template.sections[_currentSectionIndex];
  
  double get _progress {
    final filled = _filledTemplate.sectionInputs.values.where((v) => v.isNotEmpty).length;
    return filled / widget.template.sections.length;
  }

  bool get _canGenerate {
    return widget.template.sections
        .where((s) => s.required)
        .every((s) => _filledTemplate.sectionInputs[s.id]?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0A0A0A);
    const surfaceColor = Color(0xFF1A1A1A);
    const textColor = Colors.white;
    final primaryColor = widget.template.gradientColors[0];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: _generatedOutput != null
            ? _buildOutputView(primaryColor)
            : _buildFillView(primaryColor, surfaceColor, textColor),
      ),
    );
  }

  Widget _buildFillView(Color primaryColor, Color surfaceColor, Color textColor) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.template.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Section ${_currentSectionIndex + 1} of ${widget.template.sections.length}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_canGenerate)
                    GestureDetector(
                      onTap: _generateOutput,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: widget.template.gradientColors),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Generate',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: surfaceColor,
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),

        // Section Navigation Pills
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: widget.template.sections.length,
            itemBuilder: (context, index) {
              final section = widget.template.sections[index];
              final isCurrent = index == _currentSectionIndex;
              final isFilled = _filledTemplate.sectionInputs[section.id]?.isNotEmpty ?? false;
              
              return GestureDetector(
                onTap: () => setState(() => _currentSectionIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isCurrent 
                        ? primaryColor.withOpacity(0.2) 
                        : (isFilled ? surfaceColor : Colors.transparent),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCurrent ? primaryColor : (isFilled ? Colors.green : Colors.white24),
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isFilled && !isCurrent)
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.check_circle, color: Colors.green, size: 16),
                        ),
                      Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isCurrent ? primaryColor : Colors.white70,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Main Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_currentSection.icon, color: primaryColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _currentSection.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (!_currentSection.required)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Optional',
                                    style: TextStyle(fontSize: 10, color: Colors.white54),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentSection.hint,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Example/Placeholder
                if (_currentSection.placeholder != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber.withOpacity(0.8)),
                            const SizedBox(width: 8),
                            Text(
                              'Example',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentSection.placeholder!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5),
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Input Display
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 150),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isRecording ? primaryColor : Colors.white.withOpacity(0.1),
                      width: _isRecording ? 2 : 1,
                    ),
                  ),
                  child: _filledTemplate.sectionInputs[_currentSection.id]?.isNotEmpty ?? false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _filledTemplate.sectionInputs[_currentSection.id]!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _filledTemplate.sectionInputs[_currentSection.id] = '';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.refresh, color: Colors.red, size: 16),
                                        SizedBox(width: 6),
                                        Text('Re-record', style: TextStyle(color: Colors.red, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            _isRecording ? 'Listening...' : 'Tap the mic to speak',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // Bottom Controls
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Row(
            children: [
              // Previous Button
              if (_currentSectionIndex > 0)
                GestureDetector(
                  onTap: () => setState(() => _currentSectionIndex--),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white70),
                  ),
                ),
              
              const Spacer(),
              
              // Record Button
              GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isRecording ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isRecording 
                                ? [Colors.red, Colors.redAccent]
                                : widget.template.gradientColors,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording ? Colors.red : primaryColor).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.mic,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const Spacer(),
              
              // Next/Skip Button
              if (_currentSectionIndex < widget.template.sections.length - 1)
                GestureDetector(
                  onTap: () => setState(() => _currentSectionIndex++),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _currentSection.required ? 'Next' : 'Skip',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, color: Colors.white70, size: 20),
                      ],
                    ),
                  ),
                )
              else if (_canGenerate)
                GestureDetector(
                  onTap: _generateOutput,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: widget.template.gradientColors),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Generate',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOutputView(Color primaryColor) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _generatedOutput = null),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generated Output',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.template.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Output Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: SelectableText(
                _generatedOutput!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.8,
                ),
              ),
            ),
          ),
        ),

        // Bottom Actions
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _generatedOutput!));
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: widget.template.gradientColors),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.copy, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Copy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  // Share functionality
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleRecording() async {
    HapticFeedback.mediumImpact();
    
    if (_isRecording) {
      // Stop recording
      setState(() => _isRecording = false);
      // TODO: Get transcription from speech service
      // For now, simulate with placeholder
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _filledTemplate.sectionInputs[_currentSection.id] = 
            _currentSection.placeholder ?? 'Your voice input will appear here...';
      });
    } else {
      // Start recording
      setState(() => _isRecording = true);
      // TODO: Start speech recognition
    }
  }

  void _generateOutput() async {
    if (!_canGenerate) return;
    
    HapticFeedback.mediumImpact();
    setState(() => _isGenerating = true);
    
    // TODO: Call your AI service to generate output
    // For now, simulate with a combined output
    await Future.delayed(const Duration(seconds: 2));
    
    final buffer = StringBuffer();
    buffer.writeln('# ${widget.template.name}\n');
    
    for (final section in widget.template.sections) {
      final input = _filledTemplate.sectionInputs[section.id];
      if (input?.isNotEmpty ?? false) {
        buffer.writeln('## ${section.title}\n');
        buffer.writeln('$input\n');
      }
    }
    
    setState(() {
      _isGenerating = false;
      _generatedOutput = buffer.toString();
    });
  }
}

// Helper widget for min height container
class _MinHeightContainer extends StatelessWidget {
  final double min;
  final Widget child;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;

  const _MinHeightContainer({
    required this.min,
    required this.child,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: min),
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}