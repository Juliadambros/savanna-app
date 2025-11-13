class AssociacaoModel {
  final String? id;
  final String nomeCompleto;
  final String email;
  final String cpf;
  final String ra;
  final String curso;
  final String tipo;
  final String meioPagamento;
  final String status;
  final String? telefone;

  AssociacaoModel({
    this.id,
    required this.nomeCompleto,
    required this.email,
    required this.cpf,
    required this.ra,
    required this.curso,
    required this.tipo,
    required this.meioPagamento,
    this.status = 'pendente',
    this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeCompleto': nomeCompleto,
      'email': email,
      'cpf': cpf,
      'ra': ra,
      'curso': curso,
      'tipo': tipo,
      'meioPagamento': meioPagamento,
      'status': status,
      'telefone': telefone,
    };
  }

  factory AssociacaoModel.fromMap(Map<String, dynamic> map) {
    return AssociacaoModel(
      id: map['id'],
      nomeCompleto: map['nomeCompleto'] ?? '',
      email: map['email'] ?? '',
      cpf: map['cpf'] ?? '',
      ra: map['ra'] ?? '',
      curso: map['curso'] ?? '',
      tipo: map['tipo'] ?? '',
      meioPagamento: map['meioPagamento'] ?? '',
      status: map['status'] ?? 'pendente',
      telefone: map['telefone'],
    );
  }
}

