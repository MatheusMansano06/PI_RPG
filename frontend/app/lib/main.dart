import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/step_01_splash_screen.dart';
import 'services/step_05_audio_manager.dart';

void main() {
  // Aqui e o primeiro ponto do Flutter.
  // Quando o app abre, ele chama MyApp.
  runApp(const MyApp());
}

// MyApp guarda as configuracoes gerais do aplicativo.
// Ele tambem cuida da musica, porque a musica precisa tocar em todas as telas.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // O observer avisa quando o app abre, fecha ou fica em segundo plano.
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Comeca a musica depois que a primeira tela abriu.
      AudioManager().playBgm();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pausa o som quando o app sai da tela do celular.
    if (state == AppLifecycleState.resumed) {
      AudioManager().playBgm();
      return;
    }

    AudioManager().pauseBgm();
  }

  @override
  void dispose() {
    // Quando o app for destruido, limpamos o audio para nao ficar player aberto.
    WidgetsBinding.instance.removeObserver(this);
    AudioManager().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp e a "casca" principal do app Flutter.
    // A primeira tela chamada aqui e a SplashScreen.
    return MaterialApp(
      title: 'RPG Interativo Campus I',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
