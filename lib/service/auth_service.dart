import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<(User?, String?)> cadastrar(String email, String senha) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return (result.user, null);
    } on FirebaseAuthException catch (e) {
      String mensagem;

      switch (e.code) {
        case 'weak-password':
          mensagem = "A senha deve conter no mínimo 6 caracteres.";
          break;

        case 'email-already-in-use':
          mensagem = "Este email já está cadastrado.";
          break;

        case 'invalid-email':
          mensagem = "Email inválido.";
          break;

        default:
          mensagem = "Erro ao cadastrar: ${e.code}";
      }

      return (null, mensagem);
    }
  }

  Future<(User?, String?)> entrar(String email, String senha) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return (result.user, null);

    } on FirebaseAuthException catch (e) {
      String mensagem;

      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          mensagem = "Usuário ou senha inválidos.";
          break;

        case 'invalid-email':
          mensagem = "Email inválido.";
          break;

        case 'too-many-requests':
          mensagem = "Muitas tentativas. Tente novamente mais tarde.";
          break;

        default:
          mensagem = "Erro ao entrar: ${e.code}";
      }

      return (null, mensagem);
    }
  }

  Future<void> sair() async {
    await _auth.signOut();
  }

  User? usuarioAtual() => _auth.currentUser;
}


