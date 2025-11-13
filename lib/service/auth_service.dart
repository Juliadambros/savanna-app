import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> cadastrar(String email, String senha) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return result.user;
  }

  Future<User?> entrar(String email, String senha) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return result.user;
  }

  Future<void> sair() async {
    await _auth.signOut();
  }

  User? usuarioAtual() => _auth.currentUser;
}
