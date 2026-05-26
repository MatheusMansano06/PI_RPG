import '../core/network/api_client.dart';

class AuthCredentials {
  const AuthCredentials({
    required this.email,
    required this.senha,
  });

  final String email;
  final String senha;

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'senha': senha,
    };
  }
}

class AuthSession {
  const AuthSession({
    required this.email,
    required this.nome,
    this.token,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      email: (json['email'] as String?) ?? '',
      nome: (json['nome'] as String?) ?? 'Jogador',
      token: json['token'] as String?,
    );
  }

  final String email;
  final String nome;
  final String? token;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}

class AuthService {
  AuthService._({
    ApiClient? apiClient,
    this.usarBackend = false,
  }) : apiClient = apiClient ?? ApiClient();

  static final AuthService instance = AuthService._(usarBackend: false);

  final ApiClient apiClient;
  final bool usarBackend;

  Future<AuthSession> login({
    required String email,
    required String senha,
  }) async {
    final credentials = AuthCredentials(email: email, senha: senha);
    _validarCredenciais(credentials);

    if (usarBackend) {
      return _loginComBackend(credentials);
    }

    return _loginTemporario(credentials);
  }

  Future<AuthSession> _loginTemporario(AuthCredentials credentials) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    return AuthSession(
      email: credentials.email.trim(),
      nome: 'Jogador',
      token: 'fake-session-token',
    );
  }

  Future<AuthSession> _loginComBackend(AuthCredentials credentials) async {
    try {
      final response = await apiClient.post('/auth/login', credentials.toJson());
      if (response is! Map<String, dynamic>) {
        throw const AuthException('Resposta invalida do servidor.');
      }

      return AuthSession.fromJson(response);
    } on ApiException catch (error) {
      throw AuthException(error.message);
    }
  }

  void _validarCredenciais(AuthCredentials credentials) {
    final email = credentials.email.trim();
    final senha = credentials.senha.trim();

    if (email.isEmpty || senha.isEmpty) {
      throw const AuthException('Informe e-mail e senha para entrar.');
    }

    if (!email.contains('@')) {
      throw const AuthException('Informe um e-mail valido.');
    }
  }
}
