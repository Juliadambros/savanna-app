class AssociacaoModel {
  final String id;
  final String nomeCompleto;
  final String email;
  final String cpf;
  final String ra;
  final String curso;          
  final String tipo;           
  final String meioPagamento;  

  AssociacaoModel({
    required this.id,
    required this.nomeCompleto,
    required this.email,
    required this.cpf,
    required this.ra,
    required this.curso,
    required this.tipo,
    required this.meioPagamento,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nomeCompleto': nomeCompleto,
        'email': email,
        'cpf': cpf,
        'ra': ra,
        'curso': curso,
        'tipo': tipo,
        'meioPagamento': meioPagamento,
      };

  factory AssociacaoModel.fromMap(Map<String, dynamic> map) =>
      AssociacaoModel(
        id: map['id'],
        nomeCompleto: map['nomeCompleto'],
        email: map['email'],
        cpf: map['cpf'],
        ra: map['ra'],
        curso: map['curso'],
        tipo: map['tipo'],
        meioPagamento: map['meioPagamento'],
      );
}
