import 'dart:async';

import 'package:flutter/material.dart';

import '../core/navigation/cinematic_route.dart';
import '../core/theme/app_theme.dart';
import '../services/step_06_cinematic_audio_service.dart';
import '../services/step_05_audio_manager.dart';
import '../widgets/step_11_cinematic_cloud_layer.dart';
import 'auth/step_02_login_screen.dart';

// Primeira tela do app.
// Ela aparece por pouco tempo e depois manda o usuario para o login.
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
    // Depois de 2 segundos chamamos _goToLogin.
    _timer = Timer(const Duration(seconds: 2), _goToLogin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToLogin() {
    // mounted evita erro caso a tela ja tenha sido fechada.
    // _navigated evita navegar duas vezes se o usuario apertar o botao rapido.
    if (!mounted || _navigated) {
      return;
    }
    _navigated = true;

    // Antes de trocar de tela, iniciamos os sons da abertura.
    AudioManager().playBgm();
    CinematicAudioService.instance.playCloudTransition();

    // buildCloudRoute fica em core/navigation e faz a transicao visual.
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
                    'Campus I em Jogo',
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
                    'Uma forma prática de conhecer o campus.',
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
                      'Entrar no campus',
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
