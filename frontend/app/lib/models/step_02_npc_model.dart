// Modelo simples do personagem da fase.
// Exemplo: Seu Ze na entrada, Helena na Secretaria, Bia no Refeitorio.
class NpcModel {
  const NpcModel({
    required this.nome,
    required this.descricao,
    required this.falaInicial,
  });

  final String nome;
  final String descricao;
  final String falaInicial;
}
