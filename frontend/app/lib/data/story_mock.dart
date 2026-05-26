import '../models/dialogue_option_model.dart';
import '../models/game_environment_model.dart';
import '../models/npc_model.dart';
import '../models/stage_challenge_model.dart';

const List<GameEnvironmentModel> storyMockEnvironments = [
  GameEnvironmentModel(
    id: 'estacionamento_entrada',
    nome: 'Entrada/Estacionamento da PUC',
    descricao: 'O ponto inicial da jornada pelo Campus I.',
    latitude: -22.83455,
    longitude: -47.05278,
    raioMetros: 40,
    stageNumber: 1,
    missionTitle: 'Resolver o primeiro bloqueio',
    missionDescription:
        'Descubra onde regularizar a notificacao urgente sobre sua matricula.',
    introText:
        'Seu celular vibra antes mesmo da primeira aula: ha uma pendencia na matricula. A entrada do campus vira sua primeira quest.',
    npc: NpcModel(
      nome: 'Seu Ze',
      descricao: 'Orientador da entrada, conhece cada atalho do campus.',
      falaInicial:
          'Calouro, respira. Se sua matricula deu problema, voce precisa chegar ao lugar certo sem se perder.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Pedir orientacao com calma e explicar a notificacao.',
        correta: true,
        reacao:
            'Boa abordagem. Seu Ze marca o caminho da Secretaria no seu mapa.',
      ),
      DialogueOptionModel(
        texto: 'Entrar correndo sem falar com ninguem.',
        correta: false,
        reacao: 'Isso so aumenta a confusao. Primeiro colete informacao.',
      ),
      DialogueOptionModel(
        texto: 'Desistir e voltar para casa.',
        correta: false,
        reacao: 'A jornada mal comecou. Calouro persistente ganha XP.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Como pedir orientacao?',
      description:
          'Seu Ze pergunta o que aconteceu. Escolha a postura que ajuda a liberar a proxima pista.',
      rewardXp: 80,
      rewardText: 'Mapa inicial atualizado.',
      options: [
        DialogueOptionModel(
          texto: 'Mostrar a notificacao e pedir o caminho da Secretaria.',
          correta: true,
          reacao: 'Perfeito. Informacao clara gera ajuda rapida.',
        ),
        DialogueOptionModel(
          texto: 'Perguntar onde fica o refeitorio.',
          correta: false,
          reacao: 'Importante, mas ainda nao resolve a matricula.',
        ),
        DialogueOptionModel(
          texto: 'Falar que nao precisa de ajuda.',
          correta: false,
          reacao: 'Heroi solo tambem precisa de NPC tutorial.',
        ),
      ],
    ),
    completionText: 'Entrada liberada. A Secretaria foi marcada como destino.',
    nextHint: 'Siga para a Secretaria Academica e procure orientacao oficial.',
  ),
  GameEnvironmentModel(
    id: 'secretaria',
    nome: 'Secretaria Academica',
    descricao: 'Centro de informacoes academicas e registros.',
    latitude: -22.83362,
    longitude: -47.05155,
    raioMetros: 40,
    stageNumber: 2,
    missionTitle: 'Negociar sua regularizacao',
    missionDescription:
        'Converse com a Secretaria e descubra a origem da pendencia.',
    introText:
        'A fila anda devagar, mas cada resposta importa. Voce precisa ser claro, educado e persistente.',
    npc: NpcModel(
      nome: 'Helena',
      descricao: 'Atendente precisa, rapida e cheia de pistas institucionais.',
      falaInicial:
          'Achei sua pendencia. Para resolver, preciso confirmar seus dados e encaminhar voce ao setor correto.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Responder com respeito e apresentar os documentos.',
        correta: true,
        reacao: 'Helena confere tudo e reduz o misterio a uma pista concreta.',
      ),
      DialogueOptionModel(
        texto: 'Culpar o sistema e interromper a atendente.',
        correta: false,
        reacao: 'Diplomacia baixa. A quest pede paciencia.',
      ),
      DialogueOptionModel(
        texto: 'Pedir para resolver depois.',
        correta: false,
        reacao: 'Depois pode virar boss fight. Melhor agir agora.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Atendimento em 3 rodadas',
      description:
          'A melhor resposta combina educacao, clareza e pedido objetivo.',
      rewardXp: 100,
      rewardText: 'Encaminhamento academico recebido.',
      options: [
        DialogueOptionModel(
          texto: 'Confirmar dados, agradecer e perguntar o proximo setor.',
          correta: true,
          reacao: 'Resposta diplomatica. Helena desbloqueia o Predio CT.',
        ),
        DialogueOptionModel(
          texto: 'Exigir prioridade porque e seu primeiro dia.',
          correta: false,
          reacao: 'A pressao nao ajuda. Tente colaborar.',
        ),
        DialogueOptionModel(
          texto: 'Sair sem anotar o encaminhamento.',
          correta: false,
          reacao: 'Sem pista nao ha progresso.',
        ),
      ],
    ),
    completionText: 'Documentos conferidos. O Predio CT foi desbloqueado.',
    nextHint: 'Va ao Predio CT para encontrar a proxima pista.',
  ),
  GameEnvironmentModel(
    id: 'predio_ct',
    nome: 'Predio CT',
    descricao: 'Espaco ligado aos cursos e desafios de tecnologia.',
    latitude: -22.83318,
    longitude: -47.05262,
    raioMetros: 40,
    stageNumber: 3,
    missionTitle: 'Decifrar a grade curricular',
    missionDescription:
        'Entenda qual disciplina causou conflito na sua matricula.',
    introText:
        'No CT, avisos, turmas e horarios parecem um labirinto. Um professor reconhece o padrao do erro.',
    npc: NpcModel(
      nome: 'Professor Marcos',
      descricao:
          'Professor que transforma qualquer corredor em sala de estrategia.',
      falaInicial:
          'Seu problema parece choque de grade. Vamos testar se voce entende a logica dos horarios.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Comparar turma, horario e pre-requisito.',
        correta: true,
        reacao: 'Exato. Grade curricular e puzzle de dependencia.',
      ),
      DialogueOptionModel(
        texto: 'Escolher qualquer turma disponivel.',
        correta: false,
        reacao: 'Escolha aleatoria pode criar outro conflito.',
      ),
      DialogueOptionModel(
        texto: 'Ignorar pre-requisito.',
        correta: false,
        reacao: 'Pre-requisito ignorado costuma virar parede invisivel.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Enigma da grade',
      description:
          'Uma disciplina exige pre-requisito e nao pode bater horario com outra. Qual criterio vem primeiro?',
      rewardXp: 120,
      rewardText: 'Conflito de grade identificado.',
      options: [
        DialogueOptionModel(
          texto: 'Validar pre-requisito e depois conferir choque de horario.',
          correta: true,
          reacao: 'Grade resolvida. Agora recupere energia no Refeitorio.',
        ),
        DialogueOptionModel(
          texto: 'Priorizar a sala mais perto.',
          correta: false,
          reacao: 'Conforto nao resolve regra academica.',
        ),
        DialogueOptionModel(
          texto: 'Escolher a materia com nome mais facil.',
          correta: false,
          reacao: 'O sistema nao aceita carisma como pre-requisito.',
        ),
      ],
    ),
    completionText: 'Conflito tecnico entendido. Hora de recuperar energia.',
    nextHint: 'Procure o Refeitorio para recuperar energia.',
  ),
  GameEnvironmentModel(
    id: 'refeitorio',
    nome: 'Refeitorio',
    descricao: 'Ponto de encontro para pausa, estrategia e energia.',
    latitude: -22.83308,
    longitude: -47.05202,
    raioMetros: 40,
    stageNumber: 4,
    missionTitle: 'Resolver o cartao nao ativado',
    missionDescription:
        'A pausa vira desafio quando seu cartao ainda nao funciona.',
    introText:
        'A fome chega junto com outra falha: seu cartao nao foi ativado. Uma veterana percebe sua cara de loading infinito.',
    npc: NpcModel(
      nome: 'Bia',
      descricao: 'Veterana que sabe onde todo mundo se encontra entre aulas.',
      falaInicial:
          'Primeiro dia sempre cobra pedágio. Se o cartao falhou, voce precisa resolver sem travar a fila.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Sair da fila, pedir orientacao e procurar ativacao.',
        correta: true,
        reacao: 'Boa. Voce evita caos social e ganha uma pista.',
      ),
      DialogueOptionModel(
        texto: 'Insistir varias vezes no leitor.',
        correta: false,
        reacao: 'O leitor nao sobe de nivel com insistencia.',
      ),
      DialogueOptionModel(
        texto: 'Pedir para alguem pagar sem explicar.',
        correta: false,
        reacao: 'Melhor resolver a causa, nao criar nova side quest.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Cartao bloqueado',
      description:
          'Qual atitude resolve o problema e mantem a convivencia em paz?',
      rewardXp: 90,
      rewardText: 'Energia social recuperada.',
      options: [
        DialogueOptionModel(
          texto: 'Pedir ajuda, anotar o setor e liberar a fila.',
          correta: true,
          reacao: 'Perfeito. Bia aponta o caminho do H15.',
        ),
        DialogueOptionModel(
          texto: 'Ficar parado ate alguem resolver.',
          correta: false,
          reacao: 'Fila parada reduz reputacao.',
        ),
        DialogueOptionModel(
          texto: 'Ignorar o almoco e seguir sem energia.',
          correta: false,
          reacao: 'Sem energia, o proximo capitulo fica mais dificil.',
        ),
      ],
    ),
    completionText: 'Energia recuperada. O caminho para o H15 foi revelado.',
    nextHint: 'Siga para o Predio H15.',
  ),
  GameEnvironmentModel(
    id: 'predio_h15',
    nome: 'Predio H15',
    descricao: 'Predio de passagem, aulas e novas conexoes.',
    latitude: -22.83409,
    longitude: -47.05265,
    raioMetros: 40,
    stageNumber: 5,
    missionTitle: 'Encontrar a sala correta',
    missionDescription:
        'Identifique a sala certa antes que a aula importante comece.',
    introText:
        'O H15 parece simples ate voce ver placas, corredores e turmas parecidas. Um monitor oferece uma pista.',
    npc: NpcModel(
      nome: 'Lucas',
      descricao: 'Monitor que acompanha projetos e aponta atalhos praticos.',
      falaInicial:
          'Sua sala aparece no horario, mas o bloco confunde muita gente. Leia o codigo antes de escolher.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Conferir bloco, andar e numero da sala.',
        correta: true,
        reacao: 'Isso. Codigo de sala e coordenada de dungeon academica.',
      ),
      DialogueOptionModel(
        texto: 'Entrar na primeira sala cheia.',
        correta: false,
        reacao: 'Sala cheia tambem pode ser aula errada.',
      ),
      DialogueOptionModel(
        texto: 'Seguir outro calouro sem perguntar.',
        correta: false,
        reacao: 'Calouro seguindo calouro vira labirinto.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Codigo da sala',
      description:
          'O horario mostra H15, 2o andar, sala 204. Qual acao confirma o destino?',
      rewardXp: 110,
      rewardText: 'Sala correta localizada.',
      options: [
        DialogueOptionModel(
          texto: 'Subir ao 2o andar e procurar a sala 204 no H15.',
          correta: true,
          reacao: 'Sala localizada. O Laboratorio foi desbloqueado.',
        ),
        DialogueOptionModel(
          texto: 'Procurar sala 204 em qualquer predio.',
          correta: false,
          reacao: 'O predio tambem faz parte da coordenada.',
        ),
        DialogueOptionModel(
          texto: 'Esperar o professor aparecer no corredor.',
          correta: false,
          reacao: 'Estrategia passiva. O relogio nao perdoa.',
        ),
      ],
    ),
    completionText: 'H15 concluido. A etapa final esta aberta.',
    nextHint: 'Va ao Laboratorio de Computadores para finalizar.',
  ),
  GameEnvironmentModel(
    id: 'laboratorio',
    nome: 'Laboratorio de Computadores',
    descricao: 'Local onde a jornada vira entrega final.',
    latitude: -22.83409,
    longitude: -47.05265,
    raioMetros: 40,
    stageNumber: 6,
    missionTitle: 'Ajudar um colega e fechar o ciclo',
    missionDescription:
        'Use postura colaborativa para concluir o primeiro dia.',
    introText:
        'No laboratorio, seu acesso finalmente funciona. Antes de comemorar, um colega trava no mesmo problema que voce enfrentou.',
    npc: NpcModel(
      nome: 'IA do Laboratorio',
      descricao: 'Sistema experimental que valida escolhas colaborativas.',
      falaInicial:
          'Ultima validacao: o que voce faz quando outro calouro fica preso no fluxo que voce acabou de vencer?',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Compartilhar o caminho e explicar as pistas.',
        correta: true,
        reacao: 'Validado. Conhecimento compartilhado fecha a jornada.',
      ),
      DialogueOptionModel(
        texto: 'Dizer que cada um precisa descobrir sozinho.',
        correta: false,
        reacao: 'XP individual nao basta para um campus cooperativo.',
      ),
      DialogueOptionModel(
        texto: 'Fazer tudo por ele sem explicar.',
        correta: false,
        reacao: 'Ajuda real tambem ensina autonomia.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Atitude de campus',
      description:
          'Escolha a melhor forma de ajudar um colega com a matricula travada.',
      rewardXp: 150,
      rewardText: 'Espírito colaborativo desbloqueado.',
      options: [
        DialogueOptionModel(
          texto: 'Explicar o passo a passo e acompanhar ate ele entender.',
          correta: true,
          reacao: 'Conclusao perfeita. Voce virou referencia de primeiro dia.',
        ),
        DialogueOptionModel(
          texto: 'Mandar procurar sozinho na internet.',
          correta: false,
          reacao: 'Rapido, mas pouco humano.',
        ),
        DialogueOptionModel(
          texto: 'Pegar o celular dele e resolver tudo.',
          correta: false,
          reacao: 'Resolver sem ensinar nao cria progresso duradouro.',
        ),
      ],
    ),
    completionText: 'Projeto integrador concluido. O campus virou jogo.',
    nextHint: 'Conclua a missao final no laboratorio.',
  ),
];
