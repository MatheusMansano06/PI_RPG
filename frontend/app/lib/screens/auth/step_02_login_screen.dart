import 'package:flutter/material.dart';

import '../../core/navigation/cinematic_route.dart';
import '../../services/step_06_cinematic_audio_service.dart';
import '../../services/step_01_auth_service.dart';
import '../../widgets/step_11_cinematic_cloud_layer.dart';
import '../../widgets/step_01_game_background.dart';
import '../../widgets/step_02_game_card.dart';
import '../../widgets/step_05_game_text_field.dart';
import '../step_03_start_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cursoController = TextEditingController();
  final _authService = AuthService.instance;

  bool _isLoading = false;
  bool _isRegisterMode = false;

  @override
  void initState() {
    super.initState();
    // A tela comeca em modo login. O botao "Criar novo perfil" troca para cadastro.
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _telefoneController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isRegisterMode) {
        await _authService.register(
          nome: _nomeController.text,
          email: _emailController.text,
          senha: _senhaController.text,
          telefone: _telefoneController.text,
          curso: _cursoController.text,
        );
      } else {
        await _authService.login(
          email: _emailController.text,
          senha: _senhaController.text,
        );
      }

      if (!mounted) {
        return;
      }

      CinematicAudioService.instance.playCloudTransition();
      Navigator.of(
        context,
      ).pushReplacement(buildCloudRoute(const StartScreen()));
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
    if (_isLoading) {
      return;
    }

    setState(() {
      _isRegisterMode = !_isRegisterMode;
    });
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
              const Positioned.fill(
                child: CinematicCloudLayer(opacity: 0.24, speed: 1.0),
              ),
              if (showSceneDetails) ...const [
                Positioned(
                  left: 44,
                  top: 82,
                  child: _SceneDetail(
                    eyebrow: 'INÍCIO',
                    title: 'Primeiro acesso',
                    detail: 'Registro do aluno e progresso liberados',
                    icon: Icons.menu_book_outlined,
                  ),
                ),
                Positioned(
                  right: 44,
                  bottom: 82,
                  child: _SceneDetail(
                    eyebrow: 'SETOR',
                    title: 'Campus I',
                    detail: 'Rotas, pistas e personagens ativos',
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
                          if (_isRegisterMode) ...[
                            GameTextField(
                              controller: _nomeController,
                              label: 'Nome do aluno',
                              icon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                            ),
                            SizedBox(height: compact ? 10 : 14),
                            GameTextField(
                              controller: _telefoneController,
                              label: 'Telefone',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                            ),
                            SizedBox(height: compact ? 10 : 14),
                            GameTextField(
                              controller: _cursoController,
                              label: 'Curso',
                              icon: Icons.school_outlined,
                              textInputAction: TextInputAction.next,
                              enabled: !_isLoading,
                            ),
                            SizedBox(height: compact ? 10 : 14),
                          ],
                          GameTextField(
                            controller: _emailController,
                            label: 'E-mail',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            enabled: !_isLoading,
                          ),
                          SizedBox(height: compact ? 10 : 14),
                          GameTextField(
                            controller: _senhaController,
                            label: 'Senha',
                            icon: Icons.enhanced_encryption_outlined,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                            enabled: !_isLoading,
                          ),
                          SizedBox(height: compact ? 14 : 20),
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 14),
                              child: Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Color(0xFF22C55E),
                                  ),
                                ),
                              ),
                            ),
                          _JourneyButton(
                            label: _isRegisterMode
                                ? 'Cadastrar e entrar'
                                : 'Entrar na Jornada',
                            icon: _isRegisterMode
                                ? Icons.person_add_alt_1
                                : Icons.travel_explore,
                            compact: compact,
                            onPressed: _isLoading ? null : _submit,
                          ),
                          SizedBox(height: compact ? 10 : 12),
                          _JourneyButton(
                            label: _isRegisterMode
                                ? 'Voltar para login'
                                : 'Criar novo perfil',
                            icon: _isRegisterMode
                                ? Icons.login
                                : Icons.person_add_alt_1,
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
        _Badge(icon: Icons.map_outlined, label: 'Campus I • PUC-Campinas'),
        _Badge(
          icon: Icons.sports_esports_outlined,
          label: 'Modo aventura • missões e desafios',
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
          color: const Color(0xFF22C55E).withValues(alpha: 0.42),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFA7F3D0), size: 15),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFD1FAE5),
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
          Icon(icon, color: const Color(0xFF22C55E), size: 30),
          const SizedBox(height: 12),
          Text(
            eyebrow,
            style: const TextStyle(
              color: Color(0xFF6EE7B7),
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
          color: const Color(0xFF22C55E),
          size: compact ? 42 : 54,
        ),
        SizedBox(height: compact ? 10 : 14),
        Text(
          'Entrada do aluno',
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
          'Mapa de missões',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF4ADE80),
            fontSize: compact ? 17 : 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: compact ? 10 : 14),
        const _DecorativeRule(),
        SizedBox(height: compact ? 10 : 14),
        const Text(
          'Entre para explorar o campus com desafios inspirados no primeiro dia de aula.',
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
            color: const Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withValues(alpha: 0.35),
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
            const Color(0xFF22C55E).withValues(alpha: 0.65),
            const Color(0xFF10B981).withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// Botao usado somente nesta tela de login.
// Ele ficou separado porque tem texto, icone e tamanho proprio.
class _JourneyButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final height = compact ? 48.0 : 54.0;
    final backgroundColor = secondary
        ? const Color(0xFF172554)
        : const Color(0xFF15803D);
    final borderColor = secondary
        ? const Color(0xFF7DD3FC)
        : const Color(0xFFF5C542);

    return SizedBox(
      height: height,
      child: Material(
        color: enabled ? backgroundColor : const Color(0xFF64748B),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: secondary ? 18 : 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: secondary ? 13 : 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
