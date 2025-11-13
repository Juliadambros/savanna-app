class EventoModel {
  String? id;
  String nome;
  String local;
  DateTime data;
  String tipo;
  String descricao;

  EventoModel({
    this.id,
    required this.nome,
    required this.local,
    required this.data,
    required this.tipo,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'local': local,
      'data': data.toIso8601String(),
      'tipo': tipo,
      'descricao': descricao,
    };
  }

  factory EventoModel.fromMap(Map<String, dynamic> map, String id) {
    return EventoModel(
      id: id,
      nome: map['nome'] ?? '',
      local: map['local'] ?? '',
      data: DateTime.parse(map['data']),
      tipo: map['tipo'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }
}

