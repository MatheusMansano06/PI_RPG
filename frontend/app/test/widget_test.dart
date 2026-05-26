import 'package:flutter_test/flutter_test.dart';

import 'package:projeto_integrador_jogo/main.dart';

void main() {
  testWidgets('realiza login temporario e abre a tela inicial', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.text('Sua jornada academica em forma de fase.'),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Primeiro Dia'), findsOneWidget);
    expect(find.text('Entrar na Jornada'), findsOneWidget);
    expect(find.text('Criar novo personagem'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('E-mail'), 'aluno@puc.br');
    await tester.enterText(find.bySemanticsLabel('Senha'), 'senha123');
    await tester.tap(find.text('Entrar na Jornada'));

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Iniciar Jornada'), findsOneWidget);
    expect(find.text('Continuar Missao'), findsOneWidget);
  });
}
