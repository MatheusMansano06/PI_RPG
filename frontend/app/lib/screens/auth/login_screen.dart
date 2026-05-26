import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../widgets/game_background.dart';
import '../../widgets/game_card.dart';
import '../../widgets/game_text_field.dart';
import '../start_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService.instance;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(_fadeAnimation);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.login(
        email: _emailController.text,
        senha: _senhaController.text,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const StartScreen()),
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _criarConta() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Criacao de conta entra em uma proxima etapa.'),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = size.width < 420 ? 16.0 : 24.0;
    final compact = size.height < 680;
    final showSceneDetails = size.width >= 920 && size.height >= 640;

    return Scaffold(
      body: GameBackground(
        child: SafeArea(
          child: Stack(
            children: [
              if (showSceneDetails) ...const [
                Positioned(
                  left: 44,
                  top: 82,
                  child: _SceneDetail(
                    eyebrow: 'ARCO 01',
                    title: 'Primeiro acesso',
                    detail: 'Diario de bordo liberado',
                    icon: Icons.menu_book_outlined,
                  ),
                ),
                Positioned(
                  right: 44,
                  bottom: 82,
                  child: _SceneDetail(
                    eyebrow: 'SETOR',
                    title: 'Campus I',
                    detail: 'Rotas, pistas e NPCs ativos',
                    icon: Icons.account_balance_outlined,
                    alignRight: true,
                  ),
                ),
              ],
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: compact ? 16 : 24,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size.width < 520 ? 440 : 468,
                        ),
                        child: GameCard(
                          padding: EdgeInsets.all(
                            compact || size.width < 420 ? 18 : 28,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _MissionBadge(),
                              SizedBox(height: compact ? 14 : 22),
                              _TitleBlock(compact: compact),
                              SizedBox(height: compact ? 16 : 22),
                              GameTextField(
                                controller: _emailController,
                                label: 'E-mail',
                                icon: Icons.badge_outlined,
                                keyboardType: TextInputType.emailAddress,
                                enabled: !_isLoading,
                              ),
                              SizedBox(height: compact ? 10 : 14),
                              GameTextField(
                                controller: _senhaController,
                                label: 'Senha',
                                icon: Icons.enhanced_encryption_outlined,
                                obscureText: true,
                                enabled: !_isLoading,
                              ),
                              SizedBox(height: compact ? 14 : 20),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: _isLoading
                                    ? const Padding(
                                        key: ValueKey('loading'),
                                        padding: EdgeInsets.only(bottom: 14),
                                        child: Center(
                                          child: SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              color: Color(0xFFF5C542),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        key: ValueKey('idle'),
                                        height: 0,
                                      ),
                              ),
                              _JourneyButton(
                                label: 'Entrar na Jornada',
                                icon: Icons.travel_explore,
                                compact: compact,
                                onPressed: _isLoading ? null : _entrar,
                              ),
                              SizedBox(height: compact ? 10 : 12),
                              _JourneyButton(
                                label: 'Criar novo personagem',
                                icon: Icons.person_add_alt_1,
                                secondary: true,
                                compact: compact,
                                onPressed: _isLoading ? null : _criarConta,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissionBadge extends StatelessWidget {
  const _MissionBadge();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: const [
        _Badge(
          icon: Icons.location_on_outlined,
          label: 'Campus I • PUC-Campinas',
        ),
        _Badge(
          icon: Icons.radar_outlined,
          label: 'RPG interativo com geolocalização',
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.34),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFBAE6FD), size: 15),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFE0F2FE),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneDetail extends StatelessWidget {
  const _SceneDetail({
    required this.eyebrow,
    required this.title,
    required this.detail,
    required this.icon,
    this.alignRight = false,
  });

  final String eyebrow;
  final String title;
  final String detail;
  final IconData icon;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFF5C542), size: 30),
          const SizedBox(height: 12),
          Text(
            eyebrow,
            style: const TextStyle(
              color: Color(0xFFBAE6FD),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.auto_stories,
          color: const Color(0xFFF5C542),
          size: compact ? 42 : 54,
        ),
        SizedBox(height: compact ? 10 : 14),
        Text(
          'Primeiro Dia',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 31 : 38,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Missão Sobrevivência',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFF5C542),
            fontSize: compact ? 17 : 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: compact ? 10 : 14),
        const _DecorativeRule(),
        SizedBox(height: compact ? 10 : 14),
        const Text(
          'Entre no portal da jornada e continue sua aventura pelo Campus I.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 15,
            height: 1.45,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DecorativeRule extends StatelessWidget {
  const _DecorativeRule();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _RuleLine()),
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5C542),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF5C542).withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const Expanded(child: _RuleLine()),
      ],
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF38BDF8).withValues(alpha: 0.65),
            const Color(0xFFF5C542).withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _JourneyButton extends StatefulWidget {
  const _JourneyButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.compact,
    this.secondary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool compact;
  final bool secondary;

  @override
  State<_JourneyButton> createState() => _JourneyButtonState();
}

class _JourneyButtonState extends State<_JourneyButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final active = enabled && (_hovered || _pressed);
    final gradient = widget.secondary
        ? LinearGradient(
            colors: [
              const Color(0xFF0F172A).withValues(alpha: active ? 0.94 : 0.78),
              const Color(0xFF172554).withValues(alpha: active ? 0.92 : 0.72),
            ],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: active
                ? const [
                    Color(0xFF1D4ED8),
                    Color(0xFF2563EB),
                    Color(0xFFD4A51C),
                  ]
                : const [
                    Color(0xFF2563EB),
                    Color(0xFF1D4ED8),
                    Color(0xFF0F3EA8),
                  ],
          );
    final foreground = widget.secondary
        ? const Color(0xFFE0F2FE)
        : Colors.white;
    final height = widget.secondary
        ? widget.compact
              ? 44.0
              : 48.0
        : widget.compact
        ? 50.0
        : 56.0;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: Listener(
        onPointerDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onPointerUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onPointerCancel: enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        child: AnimatedScale(
          scale: !enabled
              ? 1
              : _pressed
              ? 0.985
              : _hovered
              ? 1.014
              : 1,
          duration: const Duration(milliseconds: 135),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 190),
            height: height,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.secondary
                    ? const Color(
                        0xFF7DD3FC,
                      ).withValues(alpha: active ? 0.52 : 0.32)
                    : const Color(
                        0xFFF5C542,
                      ).withValues(alpha: active ? 0.78 : 0.5),
              ),
              boxShadow: enabled
                  ? [
                      if (!widget.secondary)
                        BoxShadow(
                          color: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: active ? 0.46 : 0.3),
                          blurRadius: active ? 28 : 18,
                          offset: const Offset(0, 12),
                        ),
                      if (!widget.secondary)
                        BoxShadow(
                          color: const Color(
                            0xFFF5C542,
                          ).withValues(alpha: active ? 0.24 : 0.12),
                          blurRadius: active ? 24 : 14,
                          spreadRadius: -2,
                        ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onPressed,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: foreground,
                          size: widget.secondary ? 18 : 21,
                        ),
                        const SizedBox(width: 9),
                        Flexible(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: foreground,
                              fontSize: widget.secondary ? 13 : 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
