import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/game_environment_model.dart';
import '../../widgets/game_background.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_card.dart';
import '../../widgets/game_hud_badge.dart';
import '../../widgets/game_section_title.dart';
import 'stage_complete_screen.dart';

class StageChallengeScreen extends StatefulWidget {
  const StageChallengeScreen({super.key, required this.environment});

  final GameEnvironmentModel environment;

  @override
  State<StageChallengeScreen> createState() => _StageChallengeScreenState();
}

enum _MiniGameType { simon, reflex, mole }

class _StageChallengeScreenState extends State<StageChallengeScreen> {
  bool _completed = false;
  String _status = 'Conclua o mini-game para liberar a fase.';
  int _attempt = 0;

  _MiniGameType get _gameType {
    final mod = widget.environment.stageNumber % 3;
    if (mod == 1) {
      return _MiniGameType.simon;
    }
    if (mod == 2) {
      return _MiniGameType.reflex;
    }
    return _MiniGameType.mole;
  }

  String get _gameTitle {
    return switch (_gameType) {
      _MiniGameType.simon => 'Mini-game: Simon Says',
      _MiniGameType.reflex => 'Mini-game: Teste de Reflexo',
      _MiniGameType.mole => 'Mini-game: Whack-a-Mole',
    };
  }

  String get _gameSubtitle {
    return switch (_gameType) {
      _MiniGameType.simon => 'Memorize a sequencia de simbolos e repita sem errar.',
      _MiniGameType.reflex => 'Espere o sinal verde e toque o mais rapido possivel.',
      _MiniGameType.mole => 'Acerte 8 alvos em 15 segundos para vencer.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.environment.challenge;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 700 || size.width < 420;

    return Scaffold(
      body: GameBackground(
        imagePath: 'assets/images/backgrounds/dialog_campus.png',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 14 : 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: GameGlassCard(
                  padding: EdgeInsets.all(compact ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GameHudBadge(
                            icon: Icons.flag_outlined,
                            label: 'Fase',
                            value: '${widget.environment.stageNumber}',
                          ),
                          GameHudBadge(
                            icon: Icons.sports_esports_outlined,
                            label: 'Modo',
                            value: _gameTitle.replaceFirst('Mini-game: ', ''),
                          ),
                          GameHudBadge(
                            icon: Icons.bolt_outlined,
                            label: 'XP',
                            value: '+${challenge.rewardXp}',
                          ),
                        ],
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      GameSectionTitle(
                        eyebrow: 'DESAFIO DA MISSAO',
                        title: _gameTitle,
                        subtitle: _gameSubtitle,
                        icon: Icons.videogame_asset_outlined,
                        compact: compact,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF052E16).withValues(alpha: 0.42),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF4ADE80).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          _status,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFD1FAE5),
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMiniGame(),
                      const SizedBox(height: 16),
                      if (_completed)
                        GameButton(
                          label: 'Concluir fase',
                          icon: Icons.check_circle,
                          compact: compact,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => StageCompleteScreen(
                                  environment: widget.environment,
                                ),
                              ),
                            );
                          },
                        )
                      else
                        GameButton(
                          label: 'Reiniciar mini-game',
                          icon: Icons.refresh,
                          variant: GameButtonVariant.secondary,
                          compact: compact,
                          onPressed: () {
                            setState(() {
                              _attempt++;
                              _status = 'Mini-game reiniciado. Boa sorte.';
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniGame() {
    return switch (_gameType) {
      _MiniGameType.simon => _SimonMiniGame(
        key: ValueKey('simon-$_attempt'),
        onStatus: _updateStatus,
        onWin: _markComplete,
      ),
      _MiniGameType.reflex => _ReflexMiniGame(
        key: ValueKey('reflex-$_attempt'),
        onStatus: _updateStatus,
        onWin: _markComplete,
      ),
      _MiniGameType.mole => _WhackMiniGame(
        key: ValueKey('mole-$_attempt'),
        onStatus: _updateStatus,
        onWin: _markComplete,
      ),
    };
  }

  void _updateStatus(String value) {
    if (!mounted) {
      return;
    }
    setState(() {
      _status = value;
    });
  }

  void _markComplete(String message) {
    if (!mounted) {
      return;
    }
    setState(() {
      _completed = true;
      _status = message;
    });
  }
}

class _SimonMiniGame extends StatefulWidget {
  const _SimonMiniGame({required this.onStatus, required this.onWin, super.key});

  final ValueChanged<String> onStatus;
  final ValueChanged<String> onWin;

  @override
  State<_SimonMiniGame> createState() => _SimonMiniGameState();
}

class _SimonMiniGameState extends State<_SimonMiniGame> {
  final _rng = math.Random();
  late List<int> _sequence;
  final List<int> _input = [];
  int _showIndex = -1;
  bool _playingBack = true;

  @override
  void initState() {
    super.initState();
    _resetSequence();
  }

  void _resetSequence() {
    _sequence = List<int>.generate(4, (_) => _rng.nextInt(4));
    _input.clear();
    _playingBack = true;
    _playSequence();
  }

  Future<void> _playSequence() async {
    widget.onStatus('Memorize a sequencia...');
    for (var i = 0; i < _sequence.length; i++) {
      if (!mounted) {
        return;
      }
      setState(() => _showIndex = _sequence[i]);
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) {
        return;
      }
      setState(() => _showIndex = -1);
      await Future<void>.delayed(const Duration(milliseconds: 220));
    }
    if (!mounted) {
      return;
    }
    setState(() => _playingBack = false);
    widget.onStatus('Agora repita a sequencia correta.');
  }

  void _tap(int index) {
    if (_playingBack) {
      return;
    }
    _input.add(index);
    final pos = _input.length - 1;
    if (_input[pos] != _sequence[pos]) {
      widget.onStatus('Errou. Nova sequencia em 1s...');
      setState(() {
        _playingBack = true;
        _showIndex = -1;
      });
      Future<void>.delayed(const Duration(seconds: 1), () {
        if (!mounted) {
          return;
        }
        _resetSequence();
      });
      return;
    }
    if (_input.length == _sequence.length) {
      widget.onWin('Perfeito. Sequencia concluida.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const symbols = ['▲', '■', '●', '◆'];
    const colors = [Color(0xFF22C55E), Color(0xFF3B82F6), Color(0xFFF59E0B), Color(0xFFA855F7)];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List<Widget>.generate(4, (i) {
        final active = _showIndex == i;
        return GestureDetector(
          onTap: () => _tap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: 130,
            height: 92,
            decoration: BoxDecoration(
              color: active ? colors[i] : const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors[i].withValues(alpha: 0.85), width: 2),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: colors[i].withValues(alpha: 0.45),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                symbols[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ReflexMiniGame extends StatefulWidget {
  const _ReflexMiniGame({required this.onStatus, required this.onWin, super.key});

  final ValueChanged<String> onStatus;
  final ValueChanged<String> onWin;

  @override
  State<_ReflexMiniGame> createState() => _ReflexMiniGameState();
}

class _ReflexMiniGameState extends State<_ReflexMiniGame> {
  final _rng = math.Random();
  bool _green = false;
  bool _finished = false;
  DateTime? _start;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.onStatus('Espere o painel ficar verde e toque rapido.');
    _timer = Timer(Duration(milliseconds: 1200 + _rng.nextInt(1800)), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _green = true;
        _start = DateTime.now();
      });
      widget.onStatus('AGORA! toque no painel.');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tap() {
    if (_finished) {
      return;
    }
    if (!_green) {
      _timer?.cancel();
      setState(() {
        _finished = true;
      });
      widget.onStatus('Queimou a largada. Reinicie o mini-game.');
      return;
    }

    final elapsed = DateTime.now().difference(_start!).inMilliseconds;
    setState(() {
      _finished = true;
    });
    if (elapsed <= 450) {
      widget.onWin('Reflexo top: ${elapsed}ms. Fase liberada.');
    } else {
      widget.onStatus('Tempo ${elapsed}ms. Meta <= 450ms. Reinicie.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _green ? const Color(0xFF22C55E) : const Color(0xFFB91C1C);
    return GestureDetector(
      onTap: _tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 170,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 20,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _green ? 'TOQUE!' : 'AGUARDE...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _WhackMiniGame extends StatefulWidget {
  const _WhackMiniGame({required this.onStatus, required this.onWin, super.key});

  final ValueChanged<String> onStatus;
  final ValueChanged<String> onWin;

  @override
  State<_WhackMiniGame> createState() => _WhackMiniGameState();
}

class _WhackMiniGameState extends State<_WhackMiniGame> {
  final _rng = math.Random();
  Timer? _switchTimer;
  Timer? _countdown;
  int _target = 0;
  int _hits = 0;
  int _seconds = 15;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    widget.onStatus('Acerte 8 alvos antes do tempo acabar.');
    _target = _rng.nextInt(9);
    _switchTimer = Timer.periodic(const Duration(milliseconds: 650), (_) {
      if (!mounted || _ended) {
        return;
      }
      setState(() => _target = _rng.nextInt(9));
    });
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _ended) {
        return;
      }
      setState(() => _seconds--);
      if (_seconds <= 0) {
        _finish();
      }
    });
  }

  @override
  void dispose() {
    _switchTimer?.cancel();
    _countdown?.cancel();
    super.dispose();
  }

  void _tapCell(int index) {
    if (_ended) {
      return;
    }
    if (index == _target) {
      setState(() {
        _hits++;
        _target = _rng.nextInt(9);
      });
      if (_hits >= 8) {
        _finish(win: true);
      }
    }
  }

  void _finish({bool win = false}) {
    if (_ended) {
      return;
    }
    _ended = true;
    _switchTimer?.cancel();
    _countdown?.cancel();
    if (win) {
      widget.onWin('Você cravou $_hits acertos. Fase liberada.');
    } else {
      widget.onStatus('Tempo esgotado ($_hits/8). Reinicie e tente de novo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Acertos: $_hits/8  •  Tempo: ${_seconds}s',
          style: const TextStyle(
            color: Color(0xFFFDE68A),
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(9, (i) {
            final active = i == _target && !_ended;
            return GestureDetector(
              onTap: () => _tapCell(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF10B981) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: active ? const Color(0xFF6EE7B7) : const Color(0xFF334155),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    active ? '🎯' : '·',
                    style: TextStyle(
                      fontSize: active ? 28 : 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
