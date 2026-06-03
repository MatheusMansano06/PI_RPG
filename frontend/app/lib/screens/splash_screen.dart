import 'dart:async';

import 'package:flutter/material.dart';

import '../core/navigation/cinematic_route.dart';
import '../core/theme/app_theme.dart';
import '../services/cinematic_audio_service.dart';
import '../widgets/cinematic_cloud_layer.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _goToLogin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToLogin() {
    if (!mounted || _navigated) {
      return;
    }
    _navigated = true;
    CinematicAudioService.instance.playCloudTransition();
    Navigator.of(context).pushReplacement(buildCloudRoute(const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CinematicCloudLayer(opacity: 0.34, speed: 0.85),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.explore, color: AppTheme.accent, size: 82),
                  const SizedBox(height: 18),
                  const Text(
                    'RPG Interativo Campus I',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sua jornada academica em forma de fase.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE0F2FE),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: _goToLogin,
                    icon: const Icon(Icons.play_arrow, color: AppTheme.accent),
                    label: const Text(
                      'Entrar pela nuvem',
                      style: TextStyle(
                        color: Color(0xFFE0F2FE),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
