class Ataque {
  final String nome;
  final int dano;
  final String? efeito;

  const Ataque({required this.nome, required this.dano, this.efeito});
}

class Carta {
  final String nome;
  final int hp;
  final String tipo;
  final String fraqueza;
  final String imagem;
  final List<Ataque> ataques;

  const Carta({
    required this.nome,
    required this.hp,
    required this.tipo,
    required this.fraqueza,
    required this.imagem,
    required this.ataques,
  });
}
