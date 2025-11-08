class UsuarioModel {
  final String uid;
  final String nome;
  final String email;
  final String dataNascimento;
  final String telefone;
  final String apelidoCalouro;
  final String curso;       
  final String tipoUsuario; 

  UsuarioModel({
    required this.uid,
    required this.nome,
    required this.email,
    required this.dataNascimento,
    required this.telefone,
    required this.apelidoCalouro,
    required this.curso,
    required this.tipoUsuario,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'nome': nome,
        'email': email,
        'dataNascimento': dataNascimento,
        'telefone': telefone,
        'apelidoCalouro': apelidoCalouro,
        'curso': curso,
        'tipoUsuario': tipoUsuario,
      };

  factory UsuarioModel.fromMap(Map<String, dynamic> map) => UsuarioModel(
        uid: map['uid'],
        nome: map['nome'],
        email: map['email'],
        dataNascimento: map['dataNascimento'],
        telefone: map['telefone'],
        apelidoCalouro: map['apelidoCalouro'],
        curso: map['curso'],
        tipoUsuario: map['tipoUsuario'],
      );
}

