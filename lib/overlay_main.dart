import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter/services.dart';

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('🎯 Overlay entry point called!');
  runApp(const OverlayApp());
}

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9333EA),
          brightness: Brightness.dark,
        ),
      ),
      home: const OverlayWidget(),
    );
  }
}

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isProcessing = false;
  String _transcription = '';
  String _aiOutput = '';
  String _selectedPreset = 'Magic ✨';
  late AnimationController _pulseController;
  
  final List<Map<String, dynamic>> _presets = [
    {'id': 'magic', 'name': 'Magic ✨', 'icon': Icons.auto_fix_high},
    {'id': 'formal-email', 'name': 'Professional 💼', 'icon': Icons.business_center},
    {'id': 'casual', 'name': 'Casual 😊', 'icon': Icons.chat_bubble_outline},
    {'id': 'list', 'name': 'List 📝', 'icon': Icons.list_alt},
    {'id': 'serious', 'name': 'Serious 🎯', 'icon': Icons.psychology},
    {'id': 'funny', 'name': 'Funny 😄', 'icon': Icons.emoji_emotions},
  ];
  
  @override
  void initState() {
    super.initState();
    debugPrint('🎨 Overlay widget initialized!');
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Listen for messages from main app
    FlutterOverlayWindow.overlayListener.listen((data) {
      debugPrint('📩 Received data in overlay: $data');
      if (mounted) {
        setState(() {
          if (data is Map) {
            if (data.containsKey('transcription')) {
              _transcription = data['transcription'] as String;
              _isRecording = false;
              _isProcessing = true;
            }
            if (data.containsKey('aiOutput')) {
              _aiOutput = data['aiOutput'] as String;
              _isProcessing = false;
            }
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
  
  void _startRecording() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isRecording = true;
      _transcription = '';
      _aiOutput = '';
    });
    
    // Send message to main app to start recording
    FlutterOverlayWindow.shareData({
      'action': 'start_recording',
    });
  }
  
  void _stopRecording() {
    HapticFeedback.lightImpact();
    setState(() {
      _isRecording = false;
    });
    
    // Send message to main app to stop recording
    FlutterOverlayWindow.shareData({
      'action': 'stop_recording',
    });
  }
  
  void _generateText() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _isProcessing = true;
    });
    
    // Send message to main app to generate text
    FlutterOverlayWindow.shareData({
      'action': 'generate_text',
      'preset': _selectedPreset,
      'transcription': _transcription,
    });
  }
  
  void _copyToClipboard() async {
    if (_aiOutput.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: _aiOutput));
      HapticFeedback.mediumImpact();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Copied to clipboard! ✓', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
  
  void _close() {
    FlutterOverlayWindow.closeOverlay();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final overlayHeight = screenHeight * 0.65; // Takes up 65% of screen (more than half)
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: overlayHeight,
          margin: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF475569),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.mic, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'VoiceBubble',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                        onPressed: _close,
                      ),
                    ],
                  ),
                ),
                
                const Divider(color: Color(0xFF334155), height: 1),
                
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recording Section
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTapDown: (_) => _startRecording(),
                                onTapUp: (_) => _stopRecording(),
                                onTapCancel: () => _stopRecording(),
                                child: AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Container(
                                      width: _isRecording ? 100 + (_pulseController.value * 10) : 100,
                                      height: _isRecording ? 100 + (_pulseController.value * 10) : 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: _isRecording
                                              ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                                              : [const Color(0xFF9333EA), const Color(0xFFEC4899)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (_isRecording 
                                                    ? const Color(0xFFEF4444) 
                                                    : const Color(0xFF9333EA))
                                                .withOpacity(_isRecording ? 0.6 : 0.4),
                                            blurRadius: _isRecording ? 30 : 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        _isRecording ? Icons.stop : Icons.mic,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isRecording 
                                    ? 'Release to Stop' 
                                    : _isProcessing 
                                        ? 'Processing...' 
                                        : 'Hold to Record',
                                style: TextStyle(
                                  color: _isRecording ? const Color(0xFFEF4444) : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Transcription
                        if (_transcription.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'You said:',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF334155),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _transcription,
                              style: const TextStyle(
                                color: Color(0xFFE2E8F0),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                        
                        // Preset Selector
                        if (_transcription.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Choose your style:',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _presets.map((preset) {
                              final isSelected = _selectedPreset == preset['name'];
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _selectedPreset = preset['name'] as String;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
                                          )
                                        : null,
                                    color: isSelected ? null : const Color(0xFF334155),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF9333EA).withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        preset['icon'] as IconData,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        preset['name'] as String,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          
                          // Generate Button
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isProcessing ? null : _generateText,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9333EA),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isProcessing
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.auto_awesome, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Generate Text',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                        
                        // AI Output
                        if (_aiOutput.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your rewritten text:',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: _copyToClipboard,
                                icon: const Icon(Icons.copy, size: 16),
                                label: const Text('Copy'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF9333EA),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF9333EA).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: SelectableText(
                              _aiOutput,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ],
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
