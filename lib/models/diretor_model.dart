class DiretorModel {
  String? id;
  String nome;
  String cargo;
  String curso;

  DiretorModel({
    this.id,
    required this.nome,
    required this.cargo,
    required this.curso,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cargo': cargo,
      'curso': curso,
    };
  }

  factory DiretorModel.fromMap(Map<String, dynamic> map, String id) {
    return DiretorModel(
      id: id,
      nome: map['nome'] ?? '',
      cargo: map['cargo'] ?? '',
      curso: map['curso'] ?? '',
    );
  }
}

