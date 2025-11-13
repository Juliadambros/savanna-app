class ParceiroModel {
  String? id;
  String nome;
  String descricao;
  String contato; 

  ParceiroModel({
    this.id,
    required this.nome,
    required this.descricao,
    required this.contato,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'contato': contato,
    };
  }

  factory ParceiroModel.fromMap(Map<String, dynamic> map, String id) {
    return ParceiroModel(
      id: id,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      contato: map['contato'] ?? '',
    );
  }
}
