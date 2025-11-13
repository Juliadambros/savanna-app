class ProdutoModel {
  String? id;
  String nome;
  String descricao;
  double preco;
  bool disponivel;

  ProdutoModel({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.disponivel,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'disponivel': disponivel,
    };
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map, String id) {
    return ProdutoModel(
      id: id,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      preco: (map['preco'] ?? 0).toDouble(),
      disponivel: map['disponivel'] ?? true,
    );
  }
}
