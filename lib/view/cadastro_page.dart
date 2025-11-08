import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/service/usuario_service.dart';
import '../models/usuario_model.dart';
import 'home_page.dart';
import 'components/campo_texto.dart';
import 'components/campo_dropdown.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final data = TextEditingController();
  final telefone = TextEditingController();
  final apelido = TextEditingController();
  String? curso;
  bool carregando = false;

  final cursos = ['Computação', 'Engenharia', 'Direito', 'Administração'];

  @override
  void dispose() {
    nome.dispose();
    email.dispose();
    senha.dispose();
    data.dispose();
    telefone.dispose();
    apelido.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (nome.text.isEmpty || email.text.isEmpty || senha.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, email e senha')),
      );
      return;
    }

    setState(() => carregando = true);
    try {
      final auth = AuthService();
      final firebaseUser = await auth.cadastrar(email.text.trim(), senha.text.trim());

      if (firebaseUser != null) {
        final usuario = UsuarioModel(
          uid: firebaseUser.uid,
          nome: nome.text.trim(),
          email: email.text.trim(),
          dataNascimento: data.text.trim(),
          telefone: telefone.text.trim(),
          apelidoCalouro: apelido.text.trim(),
          curso: curso ?? '',
          tipoUsuario: 'usuario',
        );

        await UsuarioService().salvarUsuario(usuario);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CampoTexto(label: 'Nome', controller: nome),
            const SizedBox(height: 12),
            CampoTexto(label: 'Email', controller: email),
            const SizedBox(height: 12),
            CampoTexto(label: 'Senha', controller: senha, senha: true),
            const SizedBox(height: 12),
            CampoTexto(label: 'Data de nascimento', controller: data),
            const SizedBox(height: 12),
            CampoTexto(label: 'Telefone', controller: telefone),
            const SizedBox(height: 12),
            CampoTexto(label: 'Apelido de calouro', controller: apelido),
            const SizedBox(height: 12),
            CampoDropdown(
              label: 'Curso',
              valor: curso,
              itens: cursos,
              aoMudar: (v) => setState(() => curso = v),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: carregando ? null : _cadastrar,
              child: carregando ? const CircularProgressIndicator(color: Colors.white) : const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
