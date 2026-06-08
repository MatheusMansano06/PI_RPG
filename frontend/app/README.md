# Campus I em Jogo

Aplicativo Flutter criado para ajudar calouros a conhecerem o Campus I da PUC-Campinas por meio de uma experiência gamificada.

O jogador passa por ambientes reais do campus, recebe pistas, conversa com personagens e conclui desafios curtos. A ideia é transformar dúvidas comuns do primeiro dia, como matrícula, localização, sala, refeitório e uso do laboratório, em uma jornada fácil de entender.

## Como rodar

```bash
flutter pub get
flutter run
```

Para usar o mapa no Android, configure `MAPS_API_KEY` em `android/local.properties`. Mais detalhes estão em `docs/GOOGLE_MAPS_SETUP.md`.

## Partes principais

- `lib/data/step_01_roteiro_fases.dart`: roteiro das fases, personagens, falas, respostas e recompensas.
- `lib/screens`: telas numeradas na ordem em que o usuário passa pelo app.
- `lib/services`: serviços numerados por responsabilidade: login, GPS, progresso e áudio.
- `lib/widgets`: componentes visuais reutilizados nas telas, também numerados para consulta rápida.
- `android`: arquivos nativos do Android.
- `ios`: arquivos nativos do iOS.
- `backend/apiRpg`: API em Node.js usada para autenticação e serviços do projeto.

Arquivos de Linux, macOS, Windows e Web foram removidos porque esta entrega ficou focada em Android e iOS.

## Ideia para apresentação

O projeto mostra como um aplicativo pode orientar novos alunos de forma mais leve. Em vez de entregar apenas um mapa estático, o app usa narrativa, GPS e desafios para explicar caminhos e decisões do cotidiano universitário.
