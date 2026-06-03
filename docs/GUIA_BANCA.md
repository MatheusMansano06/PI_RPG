# Guia de apresentação para a banca

Este guia serve como cola técnica e roteiro de fala para o grupo. A linguagem está simples para ajudar todo mundo a explicar o projeto sem decorar código linha por linha.

## Resumo do projeto

O aplicativo se chama **Campus I em Jogo**. Ele transforma o primeiro dia de um calouro no Campus I da PUC-Campinas em uma experiência interativa.

O aluno abre o app, faz login, vê o mapa do campus, segue até pontos marcados pelo GPS e participa de fases com personagens e desafios. Cada etapa representa uma situação comum: matrícula, secretaria, grade curricular, refeitório, sala de aula e laboratório.

## Problema que o grupo resolveu

Calouros podem se sentir perdidos no começo da vida universitária. O projeto resolve isso com uma navegação mais guiada e acolhedora:

- mostra o próximo local no mapa;
- explica o objetivo de cada etapa;
- usa personagens para orientar o aluno;
- usa desafios rápidos para manter o engajamento;
- registra o progresso da jornada.

## Fluxo do usuário

1. O usuário entra ou cria um perfil.
2. A tela inicial apresenta a proposta do jogo.
3. O prólogo explica a pendência de matrícula.
4. O mapa mostra o local atual e o próximo destino.
5. Ao chegar no raio definido pelo GPS, a missão é liberada.
6. O usuário conversa com um personagem e conclui o desafio.
7. O progresso libera o próximo ambiente.
8. No final, o app mostra todas as fases concluídas.

## Como explicar a arquitetura

O projeto tem duas partes:

- **Frontend Flutter**: aplicativo visual, telas, mapa, GPS, narrativa e desafios.
- **Backend Node.js**: API usada para autenticação e serviços que podem apoiar o app.

No Flutter, a organização principal é:

- `lib/screens`: telas completas que o usuário vê.
- `lib/widgets`: componentes reaproveitados, como cards, botões, painel de missão e campos de texto.
- `lib/services`: regras de negócio, como login, progresso, localização e áudio.
- `lib/data/story_mock.dart`: roteiro das fases do jogo.
- `lib/models`: classes que organizam os dados do jogo.

## Arquivos que vale citar

- `frontend/app/lib/main.dart`: ponto inicial do app Flutter.
- `frontend/app/lib/screens/splash_screen.dart`: primeira tela e transição para login.
- `frontend/app/lib/screens/auth/login_screen.dart`: login e cadastro do aluno.
- `frontend/app/lib/screens/game/map_game_screen.dart`: mapa, GPS, raio da missão e entrada nas fases.
- `frontend/app/lib/data/story_mock.dart`: conteúdo narrativo do projeto.
- `frontend/app/lib/services/game_progress_service.dart`: controla fase atual e fases concluídas.
- `frontend/app/lib/services/localizacao_service.dart`: pede permissão e lê a posição do GPS.
- `backend/apiRpg/src/app.js`: configura as rotas da API.
- `backend/apiRpg/src/routes/auth.routes.js`: rotas de login e cadastro.
- `backend/apiRpg/src/services/authService.js`: regra de autenticação no backend.

## Falas prontas para o grupo

**Abertura**

"Nosso projeto é um app gamificado para orientar calouros pelo Campus I. A ideia foi transformar informações que normalmente ficam soltas em uma experiência guiada, com mapa, personagens e missões."

**Sobre o mapa**

"A tela do mapa usa Google Maps e Geolocator. O app calcula a distância entre o aluno e o ponto da missão. Quando ele entra no raio definido, a fase fica disponível."

**Sobre a narrativa**

"As fases ficam centralizadas em `story_mock.dart`. Isso facilita alterar textos, personagens, objetivos e recompensas sem mexer nas telas principais."

**Sobre os componentes**

"Nós criamos widgets reutilizáveis para manter o visual consistente: botões, cards, painel de missão, campos de texto e badges."

**Sobre o backend**

"O backend foi feito em Node.js com Express. Ele organiza rotas e serviços, principalmente para autenticação e integração futura com dados reais."

## Perguntas prováveis da banca

**Por que usar Flutter?**

Porque permite criar uma interface mobile com boa performance e também facilita expansão para Android, iOS e web.

**Por que usar GPS?**

Porque o objetivo é conectar a experiência do app com o campus real. O aluno não apenas lê uma instrução; ele precisa chegar ao local.

**Por que gamificação?**

Porque o primeiro dia pode ser confuso. A gamificação deixa a orientação mais leve, clara e motivadora.

**O app depende da internet?**

O mapa e a autenticação dependem de conexão. A lógica das fases e a narrativa ficam no próprio app.

**O que poderia melhorar depois?**

Persistir progresso por usuário, cadastrar fases pelo backend, melhorar acessibilidade, adicionar rotas reais no mapa e incluir mais setores do campus.

## Divisão sugerida de fala

- Pessoa 1: problema, público-alvo e objetivo do projeto.
- Pessoa 2: demonstração do app e fluxo do usuário.
- Pessoa 3: explicação do Flutter, telas e componentes.
- Pessoa 4: mapa, GPS e regras de liberação.
- Pessoa 5: backend, autenticação e próximos passos.

## Pontos fortes para destacar

- O projeto resolve um problema real de orientação no campus.
- A jornada é simples de entender.
- O mapa conecta o app ao espaço físico.
- A narrativa deixa a experiência menos burocrática.
- A estrutura do código separa telas, serviços, dados e componentes.
