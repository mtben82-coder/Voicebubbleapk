import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/preset.dart';

class AIService {
  // Your Railway backend URL
  static const String _backendUrl = 'https://voicebubble-production.up.railway.app';
  
  final Dio _dio = Dio();
  
  AIService() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }
  
  /// Convert audio file to text using backend Whisper API
  Future<String> transcribeAudio(File audioFile) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          audioFile.path,
          filename: 'audio.wav',
        ),
      });
      
      final response = await _dio.post(
        '$_backendUrl/api/transcribe',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      return response.data['text'] ?? '';
    } catch (e) {
      print('Transcription error: $e');
      throw Exception('Failed to transcribe audio: $e');
    }
  }
  
  /// Rewrite text using backend GPT-4 mini API
  Future<String> rewriteText(String text, Preset preset) async {
    try {
      // Use batch endpoint (non-streaming) for simplicity
      final response = await _dio.post(
        '$_backendUrl/api/rewrite/batch',
        data: {
          'text': text,
          'presetId': preset.id,
        },
      );
      
      return response.data['text'] ?? '';
    } catch (e) {
      print('Rewrite error: $e');
      throw Exception('Failed to rewrite text: $e');
    }
  }
  
  /// Rewrite text with streaming (word-by-word output)
  /// Yields text chunks as they arrive from the backend
  Stream<String> rewriteTextStreaming(String text, Preset preset) async* {
    try {
      final response = await _dio.post(
        '$_backendUrl/api/rewrite',
        data: {
          'text': text,
          'presetId': preset.id,
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
          },
        ),
      );
      
      // Parse SSE stream
      final stream = response.data.stream;
      String buffer = '';
      
      await for (var chunk in stream.transform(utf8.decoder)) {
        buffer += chunk;
        
        // Process complete lines
        final lines = buffer.split('\n');
        buffer = lines.last; // Keep incomplete line in buffer
        
        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();
          
          if (line.isEmpty) continue;
          
          // Parse SSE format: "data: {json}"
          if (line.startsWith('data: ')) {
            final jsonStr = line.substring(6); // Remove "data: " prefix
            
            try {
              final data = json.decode(jsonStr);
              
              // Handle chunk
              if (data['chunk'] != null) {
                yield data['chunk'] as String;
              }
              
              // Handle completion
              if (data['type'] == 'done') {
                // Stream is complete
                return;
              }
              
              // Handle error
              if (data['type'] == 'error') {
                throw Exception(data['message'] ?? 'Rewrite failed');
              }
            } catch (e) {
              print('Error parsing SSE data: $e');
              // Continue processing other chunks
            }
          }
        }
      }
    } catch (e) {
      print('Streaming rewrite error: $e');
      throw Exception('Failed to stream rewrite: $e');
    }
  }
}

