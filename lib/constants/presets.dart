import 'package:flutter/material.dart';
import '../models/preset.dart';

class AppPresets {
  // Define all preset categories with their presets
  static final List<PresetCategory> categories = [
    PresetCategory(
      name: 'All Presets',
      presets: [
        // 1. MAGIC - Always first! (Purple/Gold)
        Preset(
          id: 'magic',
          icon: Icons.auto_awesome,
          name: 'Magic',
          description: 'AI chooses the perfect format for you',
          category: 'All Presets',
          color: const Color(0xFF9333EA), // Purple
        ),
        
        // 2. MESSAGES (Blue tones)
        Preset(
          id: 'quick_reply',
          icon: Icons.flash_on,
          name: 'Quick Reply',
          description: 'Fast, concise response',
          category: 'All Presets',
          color: const Color(0xFF3B82F6), // Blue
        ),
        Preset(
          id: 'email_professional',
          icon: Icons.mail,
          name: 'Email – Professional',
          description: 'Clear professional email',
          category: 'All Presets',
          color: const Color(0xFF0EA5E9), // Sky blue
        ),
        Preset(
          id: 'email_casual',
          icon: Icons.chat_bubble,
          name: 'Email – Casual',
          description: 'Friendly informal email',
          category: 'All Presets',
          color: const Color(0xFF06B6D4), // Cyan
        ),
        
        // 3. SOCIAL MEDIA (Vibrant brand colors)
        Preset(
          id: 'x_thread',
          icon: Icons.format_list_bulleted,
          name: '𝕏 (Twitter) Thread',
          description: 'Engaging thread with hooks',
          category: 'All Presets',
          color: const Color(0xFF1DA1F2), // Twitter blue
        ),
        Preset(
          id: 'x_post',
          icon: Icons.chat,
          name: '𝕏 (Twitter) Post',
          description: 'Viral single post',
          category: 'All Presets',
          color: const Color(0xFF0284C7), // Dark twitter blue
        ),
        Preset(
          id: 'facebook_post',
          icon: Icons.public,
          name: 'Facebook Post',
          description: 'Engaging Facebook content',
          category: 'All Presets',
          color: const Color(0xFF1877F2), // Facebook blue
        ),
        Preset(
          id: 'instagram_caption',
          icon: Icons.camera_alt,
          name: 'Instagram Caption',
          description: 'Perfect caption with hashtags',
          category: 'All Presets',
          color: const Color(0xFFE1306C), // Instagram pink
        ),
        Preset(
          id: 'instagram_hook',
          icon: Icons.catching_pokemon,
          name: 'Instagram Hook',
          description: 'Attention-grabbing first line',
          category: 'All Presets',
          color: const Color(0xFFF77737), // Instagram orange
        ),
        Preset(
          id: 'linkedin_post',
          icon: Icons.work,
          name: 'LinkedIn Post',
          description: 'Professional thought leadership',
          category: 'All Presets',
          color: const Color(0xFF0A66C2), // LinkedIn blue
        ),
        
        // 4. TASKS & ORGANIZATION (Green tones)
        Preset(
          id: 'to_do',
          icon: Icons.check_circle,
          name: 'To-Do List',
          description: 'Convert thoughts to action items',
          category: 'All Presets',
          color: const Color(0xFF10B981), // Emerald
        ),
        Preset(
          id: 'meeting_notes',
          icon: Icons.event_note,
          name: 'Meeting Notes',
          description: 'Structured meeting summary',
          category: 'All Presets',
          color: const Color(0xFF14B8A6), // Teal
        ),
        
        // 5. CREATIVE WRITING (Purple/Pink tones)
        Preset(
          id: 'story_novel',
          icon: Icons.menu_book,
          name: 'Story / Novel Style',
          description: 'Transform into narrative prose',
          category: 'All Presets',
          color: const Color(0xFF8B5CF6), // Violet
        ),
        Preset(
          id: 'poem',
          icon: Icons.auto_stories,
          name: 'Poem',
          description: 'Create poetic verse',
          category: 'All Presets',
          color: const Color(0xFFC026D3), // Fuchsia
        ),
        Preset(
          id: 'script_dialogue',
          icon: Icons.theater_comedy,
          name: 'Script / Dialogue',
          description: 'Movie or play script format',
          category: 'All Presets',
          color: const Color(0xFFEC4899), // Pink
        ),
        
        // 6. REFINEMENT (Orange/Yellow/Indigo tones)
        Preset(
          id: 'shorten',
          icon: Icons.content_cut,
          name: 'Shorten',
          description: 'Reduce length, keep meaning',
          category: 'All Presets',
          color: const Color(0xFFF59E0B), // Amber
        ),
        Preset(
          id: 'expand',
          icon: Icons.add_circle,
          name: 'Expand',
          description: 'Add detail and depth',
          category: 'All Presets',
          color: const Color(0xFFF97316), // Orange
        ),
        Preset(
          id: 'formal_business',
          icon: Icons.business_center,
          name: 'Make Formal',
          description: 'Professional business tone',
          category: 'All Presets',
          color: const Color(0xFF6366F1), // Indigo
        ),
        Preset(
          id: 'casual_friendly',
          icon: Icons.emoji_emotions,
          name: 'Make Casual',
          description: 'Friendly conversational tone',
          category: 'All Presets',
          color: const Color(0xFFFBBF24), // Yellow
        ),
      ],
    ),
  ];

  // Quick access presets for the main screen (show top 4)
  static final List<Preset> quickPresets = [
    Preset(
      id: 'magic',
      icon: Icons.auto_awesome,
      name: 'Magic',
      description: 'AI chooses the perfect format',
      category: 'All Presets',
      color: const Color(0xFF9333EA),
    ),
    Preset(
      id: 'quick_reply',
      icon: Icons.flash_on,
      name: 'Quick Reply',
      description: 'Fast, concise response',
      category: 'All Presets',
      color: const Color(0xFF3B82F6),
    ),
    Preset(
      id: 'instagram_caption',
      icon: Icons.camera_alt,
      name: 'Instagram Caption',
      description: 'Perfect caption with hashtags',
      category: 'All Presets',
      color: const Color(0xFFE1306C),
    ),
    Preset(
      id: 'x_thread',
      icon: Icons.format_list_bulleted,
      name: '𝕏 Thread',
      description: 'Engaging Twitter thread',
      category: 'All Presets',
      color: const Color(0xFF1DA1F2),
    ),
  ];

  // Get all presets as a flat list
  static List<Preset> get allPresets {
    return categories.expand((category) => category.presets).toList();
  }

  // Find preset by ID
  static Preset? findById(String id) {
    try {
      return allPresets.firstWhere((preset) => preset.id == id);
    } catch (e) {
      return null;
    }
  }
}
