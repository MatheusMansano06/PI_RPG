import 'package:flutter_test/flutter_test.dart';

import 'package:projeto_integrador_jogo/main.dart';

void main() {
  testWidgets('exibe splash e tela de login', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.text('Uma forma prática de conhecer o campus.'),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Entrar na Jornada'), findsOneWidget);
    expect(find.text('Criar novo perfil'), findsOneWidget);
  });
}
