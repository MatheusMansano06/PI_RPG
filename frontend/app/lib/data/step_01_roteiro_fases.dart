import '../models/step_01_dialogue_option_model.dart';
import '../models/step_04_game_environment_model.dart';
import '../models/step_02_npc_model.dart';
import '../models/step_03_stage_challenge_model.dart';

// Roteiro central do jogo.
// Todas as telas usam esses dados para saber:
// - qual local aparece no mapa;
// - qual personagem fala;
// - qual pergunta precisa ser respondida;
// - qual texto aparece quando a missao termina.
const List<GameEnvironmentModel> roteiroFases = [
  GameEnvironmentModel(
    // Fase 1: entrada do campus.
    // Essa fase e a primeira porque o aluno comeca chegando na PUC.
    id: 'estacionamento_entrada',
    nome: 'Entrada/Estacionamento da PUC',
    descricao: 'O primeiro contato do aluno com o Campus I.',
    latitude: -22.83455,
    longitude: -47.05278,
    raioMetros: 60,
    stageNumber: 1,
    missionTitle: 'Resolver o primeiro bloqueio',
    missionDescription:
        'Descubra onde regularizar a notificação urgente sobre sua matrícula.',
    introText:
        'Seu celular vibra antes mesmo da primeira aula: existe uma pendência na matrícula. A entrada do campus vira o ponto de partida.',
    npc: NpcModel(
      nome: 'Seu Zé',
      descricao: 'Orientador da entrada, conhece cada atalho do campus.',
      falaInicial:
          'Calouro, respira. Se sua matrícula deu problema, você precisa chegar ao lugar certo sem se perder.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Pedir orientação com calma e explicar a notificação.',
        correta: true,
        reacao:
            'Boa abordagem. Seu Zé marca o caminho da Secretaria no seu mapa.',
      ),
      DialogueOptionModel(
        texto: 'Entrar correndo sem falar com ninguém.',
        correta: false,
        reacao: 'Isso só aumenta a confusão. Primeiro colete informação.',
      ),
      DialogueOptionModel(
        texto: 'Desistir e voltar para casa.',
        correta: false,
        reacao: 'A jornada mal começou. Persistência também conta ponto.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Como pedir orientação?',
      description:
          'Seu Zé pergunta o que aconteceu. Escolha a postura que ajuda a liberar a próxima pista.',
      rewardXp: 80,
      rewardText: 'Mapa inicial atualizado.',
      options: [
        DialogueOptionModel(
          texto: 'Mostrar a notificação e pedir o caminho da Secretaria.',
          correta: true,
          reacao: 'Perfeito. Informação clara gera ajuda rápida.',
        ),
        DialogueOptionModel(
          texto: 'Perguntar onde fica o refeitório.',
          correta: false,
          reacao: 'Importante, mas ainda não resolve a matrícula.',
        ),
        DialogueOptionModel(
          texto: 'Falar que não precisa de ajuda.',
          correta: false,
          reacao:
              'Mesmo quem quer se virar sozinho precisa de uma boa orientação.',
        ),
      ],
    ),
    completionText: 'Entrada liberada. A Secretaria foi marcada como destino.',
    nextHint: 'Siga para a Secretaria Acadêmica e procure orientação oficial.',
  ),
  GameEnvironmentModel(
    // Fase 2: Secretaria.
    // Aqui o aluno resolve a parte da matricula.
    id: 'secretaria',
    nome: 'Secretaria Acadêmica',
    descricao: 'Centro de informações acadêmicas e registros.',
    latitude: -22.83362,
    longitude: -47.05155,
    raioMetros: 60,
    stageNumber: 2,
    missionTitle: 'Resolver sua regularização',
    missionDescription:
        'Converse com a Secretaria e descubra a origem da pendência.',
    introText:
        'A fila anda devagar, mas cada resposta importa. Você precisa ser claro, educado e persistente.',
    npc: NpcModel(
      nome: 'Helena',
      descricao: 'Atendente precisa, rapida e cheia de pistas institucionais.',
      falaInicial:
          'Achei sua pendência. Para resolver, preciso confirmar seus dados e encaminhar você ao setor correto.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Responder com respeito e apresentar os documentos.',
        correta: true,
        reacao:
            'Helena confere tudo e transforma o problema em uma pista concreta.',
      ),
      DialogueOptionModel(
        texto: 'Culpar o sistema e interromper a atendente.',
        correta: false,
        reacao: 'A conversa trava. O melhor caminho aqui é manter a calma.',
      ),
      DialogueOptionModel(
        texto: 'Pedir para resolver depois.',
        correta: false,
        reacao:
            'Deixar para depois pode complicar o primeiro dia. Melhor agir agora.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Atendimento em 3 rodadas',
      description:
          'A melhor resposta combina educação, clareza e pedido objetivo.',
      rewardXp: 100,
      rewardText: 'Encaminhamento acadêmico recebido.',
      options: [
        DialogueOptionModel(
          texto: 'Confirmar dados, agradecer e perguntar o próximo setor.',
          correta: true,
          reacao:
              'Resposta respeitosa. Helena libera o caminho para o Prédio CT.',
        ),
        DialogueOptionModel(
          texto: 'Exigir prioridade porque é seu primeiro dia.',
          correta: false,
          reacao: 'A pressão não ajuda. Tente colaborar.',
        ),
        DialogueOptionModel(
          texto: 'Sair sem anotar o encaminhamento.',
          correta: false,
          reacao: 'Sem pista não há progresso.',
        ),
      ],
    ),
    completionText: 'Documentos conferidos. O Prédio CT foi desbloqueado.',
    nextHint: 'Vá ao Prédio CT para encontrar a próxima pista.',
  ),
  GameEnvironmentModel(
    // Fase 3: Predio CT.
    // Aqui a historia fala sobre grade e materia.
    id: 'predio_ct',
    nome: 'Prédio CT',
    descricao: 'Espaço ligado aos cursos e desafios de tecnologia.',
    latitude: -22.83318,
    longitude: -47.05262,
    raioMetros: 60,
    stageNumber: 3,
    missionTitle: 'Decifrar a grade curricular',
    missionDescription:
        'Entenda qual disciplina causou conflito na sua matrícula.',
    introText:
        'No CT, avisos, turmas e horários parecem um labirinto. Um professor reconhece o padrão do erro.',
    npc: NpcModel(
      nome: 'Professor Marcos',
      descricao:
          'Professor que transforma qualquer corredor em sala de estratégia.',
      falaInicial:
          'Seu problema parece choque de grade. Vamos testar se você entende a lógica dos horários.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Comparar turma, horário e pré-requisito.',
        correta: true,
        reacao:
            'Exato. A grade curricular depende de ordem, horário e pré-requisito.',
      ),
      DialogueOptionModel(
        texto: 'Escolher qualquer turma disponível.',
        correta: false,
        reacao: 'Escolha aleatória pode criar outro conflito.',
      ),
      DialogueOptionModel(
        texto: 'Ignorar pré-requisito.',
        correta: false,
        reacao: 'Pré-requisito ignorado costuma bloquear a matrícula depois.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Enigma da grade',
      description:
          'Uma disciplina exige pré-requisito e não pode bater horário com outra. Qual critério vem primeiro?',
      rewardXp: 120,
      rewardText: 'Conflito de grade identificado.',
      options: [
        DialogueOptionModel(
          texto: 'Validar pré-requisito e depois conferir choque de horário.',
          correta: true,
          reacao: 'Grade resolvida. Agora recupere energia no Refeitório.',
        ),
        DialogueOptionModel(
          texto: 'Priorizar a sala mais perto.',
          correta: false,
          reacao: 'Conforto não resolve regra acadêmica.',
        ),
        DialogueOptionModel(
          texto: 'Escolher a materia com nome mais facil.',
          correta: false,
          reacao: 'O sistema não aceita simpatia como pré-requisito.',
        ),
      ],
    ),
    completionText: 'Conflito tecnico entendido. Hora de recuperar energia.',
    nextHint: 'Procure o Refeitório para recuperar energia.',
  ),
  GameEnvironmentModel(
    // Fase 4: Refeitorio.
    // Colocamos essa parte para mostrar uma situacao comum do primeiro dia.
    id: 'refeitorio',
    nome: 'Refeitório',
    descricao: 'Ponto de encontro para pausa, estratégia e energia.',
    latitude: -22.83308,
    longitude: -47.05202,
    raioMetros: 60,
    stageNumber: 4,
    missionTitle: 'Resolver o cartão não ativado',
    missionDescription:
        'A pausa vira desafio quando seu cartão ainda não funciona.',
    introText:
        'A fome chega junto com outra falha: seu cartão ainda não foi ativado. Uma veterana percebe sua indecisão na fila.',
    npc: NpcModel(
      nome: 'Bia',
      descricao: 'Veterana que sabe onde todo mundo se encontra entre aulas.',
      falaInicial:
          'Primeiro dia sempre traz surpresa. Se o cartão falhou, você precisa resolver sem travar a fila.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Sair da fila, pedir orientação e procurar ativação.',
        correta: true,
        reacao: 'Boa. Você evita confusão na fila e ganha uma pista.',
      ),
      DialogueOptionModel(
        texto: 'Insistir várias vezes no leitor.',
        correta: false,
        reacao: 'O leitor não muda só porque você tentou de novo.',
      ),
      DialogueOptionModel(
        texto: 'Pedir para alguem pagar sem explicar.',
        correta: false,
        reacao: 'Melhor resolver a causa, não criar outro problema.',
      ),
    ],
    challenge: StageChallengeModel(
      title: 'Cartao bloqueado',
      description:
          'Qual atitude resolve o problema e mantém a convivência em paz?',
      rewardXp: 90,
      rewardText: 'Energia social recuperada.',
      options: [
        DialogueOptionModel(
          texto: 'Pedir ajuda, anotar o setor e liberar a fila.',
          correta: true,
          reacao: 'Perfeito. Bia aponta o caminho do H15.',
        ),
        DialogueOptionModel(
          texto: 'Ficar parado até alguém resolver.',
          correta: false,
          reacao: 'Fila parada atrapalha todo mundo.',
        ),
        DialogueOptionModel(
          texto: 'Ignorar o almoço e seguir sem energia.',
          correta: false,
          reacao: 'Sem energia, a próxima etapa fica mais difícil.',
        ),
      ],
    ),
    completionText: 'Energia recuperada. O caminho para o H15 foi revelado.',
    nextHint: 'Siga para o Prédio H15.',
  ),
  GameEnvironmentModel(
    // Fase 5: Predio H15.
    // O objetivo e achar a sala certa pelo codigo.
    id: 'predio_h15',
    nome: 'Prédio H15',
    descricao: 'Prédio de passagem, aulas e novas conexões.',
    latitude: -22.83409,
    longitude: -47.05265,
    raioMetros: 60,
    stageNumber: 5,
    missionTitle: 'Encontrar a sala correta',
    missionDescription:
        'Identifique a sala certa antes que a aula importante comece.',
    introText:
        'O H15 parece simples até você ver placas, corredores e turmas parecidas. Um monitor oferece uma pista.',
    npc: NpcModel(
      nome: 'Lucas',
      descricao: 'Monitor que acompanha projetos e aponta atalhos praticos.',
      falaInicial:
          'Sua sala aparece no horário, mas o bloco confunde muita gente. Leia o código antes de escolher.',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Conferir bloco, andar e número da sala.',
        correta: true,
        reacao: 'Isso. Código de sala é como coordenada dentro do campus.',
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
          reacao: 'Sala localizada. O Laboratório foi desbloqueado.',
        ),
        DialogueOptionModel(
          texto: 'Procurar sala 204 em qualquer predio.',
          correta: false,
          reacao: 'O predio tambem faz parte da coordenada.',
        ),
        DialogueOptionModel(
          texto: 'Esperar o professor aparecer no corredor.',
          correta: false,
          reacao: 'Estratégia passiva. O relógio não perdoa.',
        ),
      ],
    ),
    completionText: 'H15 concluído. A etapa final está aberta.',
    nextHint: 'Vá ao Laboratório de Computadores para finalizar.',
  ),
  GameEnvironmentModel(
    // Fase 6: Laboratorio.
    // Essa e a etapa final, fechando a jornada do aluno.
    id: 'laboratorio',
    nome: 'Laboratório de Computadores',
    descricao: 'Local onde a jornada vira entrega final.',
    latitude: -22.83409,
    longitude: -47.05265,
    raioMetros: 60,
    stageNumber: 6,
    missionTitle: 'Ajudar um colega e fechar o ciclo',
    missionDescription:
        'Use postura colaborativa para concluir o primeiro dia.',
    introText:
        'No laboratório, seu acesso finalmente funciona. Antes de comemorar, um colega passa pelo mesmo problema que você enfrentou.',
    npc: NpcModel(
      nome: 'Tutor do Laboratório',
      descricao: 'Monitor do espaço, focado em orientar alunos com calma.',
      falaInicial:
          'Última situação: o que você faz quando outro calouro fica preso no caminho que você acabou de entender?',
    ),
    dialogue: [
      DialogueOptionModel(
        texto: 'Compartilhar o caminho e explicar as pistas.',
        correta: true,
        reacao: 'Boa escolha. Conhecimento compartilhado fecha a jornada.',
      ),
      DialogueOptionModel(
        texto: 'Dizer que cada um precisa descobrir sozinho.',
        correta: false,
        reacao:
            'Aprender sozinho ajuda, mas o campus funciona melhor com colaboração.',
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
          'Escolha a melhor forma de ajudar um colega com a matrícula travada.',
      rewardXp: 150,
      rewardText: 'Espírito colaborativo desbloqueado.',
      options: [
        DialogueOptionModel(
          texto: 'Explicar o passo a passo e acompanhar até ele entender.',
          correta: true,
          reacao: 'Conclusão perfeita. Você virou referência de primeiro dia.',
        ),
        DialogueOptionModel(
          texto: 'Mandar procurar sozinho na internet.',
          correta: false,
          reacao: 'Rápido, mas pouco acolhedor.',
        ),
        DialogueOptionModel(
          texto: 'Pegar o celular dele e resolver tudo.',
          correta: false,
          reacao: 'Resolver sem ensinar não cria autonomia.',
        ),
      ],
    ),
    completionText:
        'Projeto integrador concluído. O campus virou experiência interativa.',
    nextHint: 'Conclua a missão final no laboratório.',
  ),
];
