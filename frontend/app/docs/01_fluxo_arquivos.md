# Sequencia dos arquivos

Os arquivos do Flutter foram numerados para bater com a ordem do app.

Para estudar com prints visuais e trechos de codigo, abra tambem:

- `docs/03_site_estudo_fluxo.html`

## Fluxo principal

1. `lib/main.dart`: abre o app e carrega a splash.
2. `lib/screens/step_01_splash_screen.dart`: tela inicial curta.
3. `lib/screens/auth/step_02_login_screen.dart`: login e cadastro.
4. `lib/screens/step_03_start_screen.dart`: menu principal.
5. `lib/screens/step_04_prologue_screen.dart`: historia inicial.
6. `lib/screens/game/step_05_map_game_screen.dart`: mapa, GPS e missao atual.
7. `lib/screens/game/step_06_stage_intro_screen.dart`: entrada da fase.
8. `lib/screens/game/step_07_npc_dialogue_screen.dart`: conversa com personagem.
9. `lib/screens/game/step_08_stage_challenge_screen.dart`: pergunta da fase.
10. `lib/screens/game/step_09_stage_complete_screen.dart`: conclui e libera a proxima.
11. `lib/screens/game/step_10_end_game_screen.dart`: final do jogo.
12. `lib/screens/step_11_progress_screen.dart`: progresso geral.
13. `lib/screens/step_12_settings_screen.dart`: ajustes e informacoes.

## Dados, servicos e widgets

- `lib/data/step_01_roteiro_fases.dart`: locais, personagens e perguntas.
- `lib/services/step_01_auth_service.dart`: login e cadastro.
- `lib/services/step_02_localizacao_service.dart`: permissao e GPS.
- `lib/services/step_03_location_check_service.dart`: checagem com backend.
- `lib/services/step_04_game_progress_service.dart`: fase atual e fases concluidas.
- `lib/services/step_05_audio_manager.dart`: musica e efeitos.
- `lib/services/step_06_cinematic_audio_service.dart`: som curto de transicao.
