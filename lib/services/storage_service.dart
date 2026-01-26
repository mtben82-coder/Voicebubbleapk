import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/archived_item.dart';
import '../models/recording_item.dart';
import '../models/project.dart';
import '../models/tag.dart';

class StorageService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _archivedItemsBoxName = 'archived_items';
  static const String _recordingItemsBoxName = 'recording_items';
  static const String _projectsBoxName = 'projects';
  
  /// Initialize Hive and register adapters
  static Future<void> initialize() async {
    debugPrint('🔧 Starting Hive initialization...');
    await Hive.initFlutter();
    debugPrint('✅ Hive.initFlutter() completed!');
    
    // Register Hive type adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ArchivedItemAdapter());
      debugPrint('✅ ArchivedItemAdapter registered (typeId: 0)');
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(RecordingItemAdapter());
      debugPrint('✅ RecordingItemAdapter registered (typeId: 1)');
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProjectAdapter());
      debugPrint('✅ ProjectAdapter registered (typeId: 2)');
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(TagAdapter());
      debugPrint('✅ TagAdapter registered (typeId: 3)');
    }
    
    debugPrint('🎉 ALL HIVE SETUP COMPLETE!');
  }
  
  /// Check if onboarding has been completed
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
  
  /// Mark onboarding as complete
  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }
  
  /// Get archived items box
  static Future<Box<ArchivedItem>> getArchivedItemsBox() async {
    if (!Hive.isBoxOpen(_archivedItemsBoxName)) {
      return await Hive.openBox<ArchivedItem>(_archivedItemsBoxName);
    }
    return Hive.box<ArchivedItem>(_archivedItemsBoxName);
  }
  
  /// Get recording items box (new model)
  static Future<Box<RecordingItem>> getRecordingItemsBox() async {
    if (!Hive.isBoxOpen(_recordingItemsBoxName)) {
      return await Hive.openBox<RecordingItem>(_recordingItemsBoxName);
    }
    return Hive.box<RecordingItem>(_recordingItemsBoxName);
  }
  
  /// Clear all app data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (Hive.isBoxOpen(_archivedItemsBoxName)) {
      final box = Hive.box<ArchivedItem>(_archivedItemsBoxName);
      await box.clear();
    }
    
    if (Hive.isBoxOpen(_recordingItemsBoxName)) {
      final box = Hive.box<RecordingItem>(_recordingItemsBoxName);
      await box.clear();
    }
    
    if (Hive.isBoxOpen(_projectsBoxName)) {
      final box = Hive.box<Project>(_projectsBoxName);
      await box.clear();
    }
  }
}

