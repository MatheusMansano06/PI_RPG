import '../core/network/api_client.dart';

// Dados usados para fazer login.
class AuthCredentials {
  const AuthCredentials({required this.email, required this.senha});

  final String email;
  final String senha;

  Map<String, dynamic> toJson() {
    // O backend espera email e senha em formato JSON.
    return {'email': email.trim(), 'senha': senha};
  }
}

// Dados usados quando o aluno cria cadastro.
class RegisterCredentials {
  const RegisterCredentials({
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.curso,
  });

  final String nome;
  final String email;
  final String senha;
  final String telefone;
  final String curso;

  Map<String, dynamic> toJson() {
    // Aqui os dados do cadastro vao para o backend.
    return {
      'nome': nome.trim(),
      'email': email.trim(),
      'senha': senha,
      'telefone': telefone.trim(),
      'curso': curso.trim(),
    };
  }
}

// Dados que voltam do backend depois de login ou cadastro.
class AuthSession {
  const AuthSession({
    required this.email,
    required this.nome,
    this.telefone,
    this.curso,
    this.token,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    // Se o backend nao mandar nome, usamos Jogador para nao quebrar a tela.
    return AuthSession(
      email: (json['email'] as String?) ?? '',
      nome: (json['nome'] as String?) ?? 'Jogador',
      telefone: json['telefone'] as String?,
      curso: json['curso'] as String?,
      token: json['token'] as String?,
    );
  }

  final String email;
  final String nome;
  final String? telefone;
  final String? curso;
  final String? token;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}

// Servico chamado pela tela 02_login_screen.
// Ele valida os campos e depois conversa com a API.
class AuthService {
  AuthService._({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();

  static final AuthService instance = AuthService._();

  final ApiClient apiClient;

  Future<AuthSession> login({
    required String email,
    required String senha,
  }) async {
    // Primeiro montamos um objeto com os dados digitados.
    final credentials = AuthCredentials(email: email, senha: senha);

    // Depois validamos antes de chamar o backend.
    _validarCredenciais(credentials);

    return _loginComBackend(credentials);
  }

  Future<AuthSession> _loginComBackend(AuthCredentials credentials) async {
    try {
      // Chama a rota POST /auth/login no backend.
      final response = await apiClient.post(
        '/auth/login',
        credentials.toJson(),
      );
      if (response is! Map<String, dynamic>) {
        throw const AuthException('Resposta inválida do servidor.');
      }

      return AuthSession.fromJson(response);
    } on ApiException catch (error) {
      throw AuthException(error.message);
    }
  }

  Future<AuthSession> register({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
    required String curso,
  }) async {
    // Cadastro usa dados basicos do aluno.
    final credentials = RegisterCredentials(
      nome: nome,
      email: email,
      senha: senha,
      telefone: telefone,
      curso: curso,
    );

    // Validamos aqui para mostrar erro antes de mandar para API.
    _validarCadastro(credentials);

    return _registerComBackend(credentials);
  }

  Future<AuthSession> _registerComBackend(
    RegisterCredentials credentials,
  ) async {
    try {
      // Chama a rota POST /auth/register no backend.
      final response = await apiClient.post(
        '/auth/register',
        credentials.toJson(),
      );
      if (response is! Map<String, dynamic>) {
        throw const AuthException('Resposta inválida do servidor.');
      }

      return AuthSession.fromJson(response);
    } on ApiException catch (error) {
      throw AuthException(error.message);
    }
  }

  void _validarCredenciais(AuthCredentials credentials) {
    // Validacao simples feita no app.
    // O backend tambem valida, mas assim o usuario recebe resposta mais rapida.
    final email = credentials.email.trim();
    final senha = credentials.senha.trim();

    if (email.isEmpty || senha.isEmpty) {
      throw const AuthException('Informe e-mail e senha para entrar.');
    }

    if (!email.contains('@')) {
      throw const AuthException('Informe um e-mail válido.');
    }
  }

  void _validarCadastro(RegisterCredentials credentials) {
    // Cadastro precisa de nome alem do email e senha.
    final nome = credentials.nome.trim();
    final authCredentials = AuthCredentials(
      email: credentials.email,
      senha: credentials.senha,
    );

    if (nome.isEmpty) {
      throw const AuthException('Informe o nome do aluno.');
    }

    _validarCredenciais(authCredentials);

    if (credentials.telefone.trim().isEmpty) {
      throw const AuthException('Informe o telefone.');
    }

    final telefoneDigits = credentials.telefone.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    if (telefoneDigits.length < 8) {
      throw const AuthException('Informe um telefone válido.');
    }

    if (credentials.curso.trim().isEmpty) {
      throw const AuthException('Informe o curso.');
    }

    if (credentials.senha.trim().length < 6) {
      throw const AuthException('A senha precisa ter pelo menos 6 caracteres.');
    }
  }
}
