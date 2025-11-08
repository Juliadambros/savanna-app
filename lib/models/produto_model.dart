class ProdutoModel {
  final String id;
  final String nome;
  final String categoria;     
  final String tamanho;     
  final String cor;          
  final double preco;
  final String descricao;
  final String imagemUrl;
  final bool personalizado;  

  ProdutoModel({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.tamanho,
    required this.cor,
    required this.preco,
    required this.descricao,
    required this.imagemUrl,
    required this.personalizado,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'categoria': categoria,
        'tamanho': tamanho,
        'cor': cor,
        'preco': preco,
        'descricao': descricao,
        'imagemUrl': imagemUrl,
        'personalizado': personalizado,
      };

  factory ProdutoModel.fromMap(Map<String, dynamic> map) => ProdutoModel(
        id: map['id'],
        nome: map['nome'],
        categoria: map['categoria'],
        tamanho: map['tamanho'],
        cor: map['cor'],
        preco: map['preco'],
        descricao: map['descricao'],
        imagemUrl: map['imagemUrl'],
        personalizado: map['personalizado'],
      );
}
