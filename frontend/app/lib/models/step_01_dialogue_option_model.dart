// Opcao de resposta usada em dialogos e perguntas.
// Cada opcao tem um texto, se esta certa ou errada, e a reacao mostrada na tela.
class DialogueOptionModel {
  const DialogueOptionModel({
    required this.texto,
    required this.correta,
    required this.reacao,
  });

  final String texto;
  final bool correta;
  final String reacao;
}
