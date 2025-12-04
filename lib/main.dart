import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/app_state_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main/home_screen.dart';
import 'screens/onboarding/onboarding_one.dart';
import 'screens/onboarding/onboarding_two.dart';
import 'screens/onboarding/onboarding_three_new.dart';
import 'screens/onboarding/permissions_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/paywall/paywall_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization error: $e');
    debugPrint('⚠️ App will continue but auth features may not work');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'VoiceBubble',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark, // Always dark mode
              primaryColor: const Color(0xFF3B82F6), // Blue
              scaffoldBackgroundColor: const Color(0xFF000000),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    
    if (mounted) {
      if (hasCompletedOnboarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingFlow(
              onComplete: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasCompletedOnboarding', true);
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.mic,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'VoiceBubble',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingFlow extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingFlow({super.key, required this.onComplete});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
    } else {
      widget.onComplete();
    }
  }

  void _handleSignIn() {
    _nextStep(); // Go to permissions after sign-in
  }

  void _closePaywall() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return OnboardingOne(onNext: _nextStep);
      case 1:
        return OnboardingTwo(onNext: _nextStep);
      case 2:
        return OnboardingThreeNew(onNext: _nextStep);
      case 3:
        return SignInScreen(onSignIn: _handleSignIn);
      case 4:
        return PermissionsScreen(onComplete: _nextStep);
      case 5:
        return PaywallScreen(
          onSubscribe: () {
            // TODO: Implement subscription
            widget.onComplete();
          },
          onRestore: () {
            // TODO: Implement restore
          },
          onClose: _closePaywall,
        );
      default:
        return const HomeScreen();
    }
  }
}
