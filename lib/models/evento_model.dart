class EventoModel {
  final String id;
  final String titulo;
  final String descricao;
  final String data;
  final String local;
  final double preco;
  final String tipo; 

  EventoModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.local,
    required this.preco,
    required this.tipo,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'data': data,
        'local': local,
        'preco': preco,
        'tipo': tipo,
      };

  factory EventoModel.fromMap(Map<String, dynamic> map) => EventoModel(
        id: map['id'],
        titulo: map['titulo'],
        descricao: map['descricao'],
        data: map['data'],
        local: map['local'],
        preco: map['preco'],
        tipo: map['tipo'],
      );
}
