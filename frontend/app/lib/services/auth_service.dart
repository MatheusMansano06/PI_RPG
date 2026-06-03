import '../core/network/api_client.dart';

class AuthCredentials {
  const AuthCredentials({required this.email, required this.senha});

  final String email;
  final String senha;

  Map<String, dynamic> toJson() {
    return {'email': email.trim(), 'senha': senha};
  }
}

class RegisterCredentials {
  const RegisterCredentials({
    required this.nome,
    required this.email,
    required this.senha,
  });

  final String nome;
  final String email;
  final String senha;

  Map<String, dynamic> toJson() {
    return {'nome': nome.trim(), 'email': email.trim(), 'senha': senha};
  }
}

class AuthSession {
  const AuthSession({required this.email, required this.nome, this.token});

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
  AuthService._({ApiClient? apiClient}) : apiClient = apiClient ?? ApiClient();

  static final AuthService instance = AuthService._();

  final ApiClient apiClient;

  Future<AuthSession> login({
    required String email,
    required String senha,
  }) async {
    final credentials = AuthCredentials(email: email, senha: senha);
    _validarCredenciais(credentials);

    return _loginComBackend(credentials);
  }

  Future<AuthSession> _loginComBackend(AuthCredentials credentials) async {
    try {
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
  }) async {
    final credentials = RegisterCredentials(
      nome: nome,
      email: email,
      senha: senha,
    );
    _validarCadastro(credentials);

    return _registerComBackend(credentials);
  }

  Future<AuthSession> _registerComBackend(
    RegisterCredentials credentials,
  ) async {
    try {
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
    final nome = credentials.nome.trim();
    final authCredentials = AuthCredentials(
      email: credentials.email,
      senha: credentials.senha,
    );

    if (nome.isEmpty) {
      throw const AuthException('Informe o nome do personagem.');
    }

    _validarCredenciais(authCredentials);

    if (credentials.senha.trim().length < 6) {
      throw const AuthException('A senha precisa ter pelo menos 6 caracteres.');
    }
  }
}
