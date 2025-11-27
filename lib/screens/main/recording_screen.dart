import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../services/ai_service.dart';
import 'preset_selection_screen.dart';
import 'result_screen.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});
  
  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AIService _aiService = AIService();
  bool _isRecording = false;
  bool _isTranscribing = false;
  String _transcription = '';
  String? _audioPath;
  late AnimationController _pulseController;
  DateTime? _recordingStartTime;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _startRecording();
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }
  
  Future<void> _startRecording() async {
    try {
      // Check permission
      if (!await _audioRecorder.hasPermission()) {
        print('No microphone permission');
        return;
      }

      // Get temp directory
      final directory = await getTemporaryDirectory();
      _audioPath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Start recording with high quality settings
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // High quality AAC
          bitRate: 128000, // 128kbps
          sampleRate: 44100, // CD quality
        ),
        path: _audioPath!,
      );

      setState(() {
        _isRecording = true;
        _recordingStartTime = DateTime.now();
      });

      print('Recording started: $_audioPath');
    } catch (e) {
      print('Error starting recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }
  
  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      
      setState(() {
        _isRecording = false;
      });

      if (path != null && path.isNotEmpty) {
        print('Recording stopped: $path');
        await _transcribeAudio(path);
      }
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _transcribeAudio(String path) async {
    setState(() {
      _isTranscribing = true;
    });

    try {
      final audioFile = File(path);
      print('Transcribing audio file: ${audioFile.path}');
      print('File size: ${await audioFile.length()} bytes');
      
      // Use Whisper API via backend
      final transcription = await _aiService.transcribeAudio(audioFile);
      
      setState(() {
        _transcription = transcription;
        _isTranscribing = false;
      });

      // Update app state
      context.read<AppStateProvider>().setTranscription(transcription);
      
      print('Transcription complete: $transcription');
    } catch (e) {
      print('Transcription error: $e');
      setState(() {
        _isTranscribing = false;
      });
      
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transcription failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getRecordingDuration() {
    if (_recordingStartTime == null) return '0:00';
    final duration = DateTime.now().difference(_recordingStartTime!);
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  Future<void> _handleDone() async {
    if (_isRecording) {
      await _stopRecording();
      return; // Wait for transcription to complete
    }
    
    final appState = context.read<AppStateProvider>();
    
    if (_transcription.isEmpty) {
      // No transcription, go back
      if (mounted) Navigator.pop(context);
      return;
    }
    
    if (appState.selectedPreset != null) {
      // Preset already selected, process and go to result
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(),
          ),
        );
      }
    } else {
      // No preset, go to selection
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PresetSelectionScreen(fromRecording: true),
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F5F7);
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    
    final selectedPreset = context.watch<AppStateProvider>().selectedPreset;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: textColor,
                  ),
                ),
              ),
            ),
            
            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated microphone
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulse animation
                        if (_isRecording)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 160 + (40 * _pulseController.value),
                                height: 160 + (40 * _pulseController.value),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: const Color(0xFFEF4444).withOpacity(
                                    0.2 * (1 - _pulseController.value),
                                  ),
                                ),
                              );
                            },
                          ),
                        // Microphone button
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(160),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDC2626).withOpacity(0.5),
                                blurRadius: 40,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mic,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    
                    // Status
                    Text(
                      _isTranscribing
                          ? 'Transcribing...'
                          : _isRecording
                              ? 'Recording... ${_getRecordingDuration()}'
                              : 'Processing',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isTranscribing
                          ? 'Using Whisper AI for perfect transcription'
                          : _isRecording
                              ? 'Speak naturally - no time limit!'
                              : 'Please wait...',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Selected Preset
                    if (selectedPreset != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'Using: ${selectedPreset.name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? const Color(0xFFE9D5FF) : const Color(0xFF9333EA),
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    
                    // Transcription
                    if (_transcription.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '"$_transcription"',
                          style: TextStyle(
                            fontSize: 16,
                            color: secondaryTextColor,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Done button
            if (!_isTranscribing)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _isRecording ? _handleDone : null,
                    child: Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.white : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(128),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.stop,
                          size: 48,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Transcribing indicator
            if (_isTranscribing)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              isDark ? const Color(0xFFE9D5FF) : const Color(0xFF9333EA),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Processing with Whisper AI...',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.w500,
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
    );
  }
}

