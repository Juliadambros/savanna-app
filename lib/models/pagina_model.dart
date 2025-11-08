class PaginaModel {
  final String id;
  final Map<String, dynamic> conteudo;

  PaginaModel({
    required this.id,
    required this.conteudo,
  });

  Map<String, dynamic> toMap() => {
        'conteudo': conteudo,
      };

  factory PaginaModel.fromMap(Map<String, dynamic> map) {
    return PaginaModel(
      id: map['id'] ?? '',
      conteudo: Map<String, dynamic>.from(map['conteudo'] ?? {}),
    );
  }
}

