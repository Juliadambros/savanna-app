class SobreNosModel {
  String? id;
  String titulo;
  String conteudo;

  SobreNosModel({
    this.id,
    required this.titulo,
    required this.conteudo,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'conteudo': conteudo,
    };
  }

  factory SobreNosModel.fromMap(Map<String, dynamic> map, String id) {
    return SobreNosModel(
      id: id,
      titulo: map['titulo'] ?? '',
      conteudo: map['conteudo'] ?? '',
    );
  }
}
