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
