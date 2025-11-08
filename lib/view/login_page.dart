import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/service/usuario_service.dart';
import 'home_page.dart';
import 'cadastro_page.dart';
import 'components/campo_texto.dart';

class LoginPage extends StatefulWidget {
  final String tipo;
  const LoginPage({super.key, required this.tipo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    setState(() => carregando = true);
    try {
      final auth = AuthService();
      final user = await auth.entrar(
        emailController.text.trim(),
        senhaController.text.trim(),
      );

      if (user != null) {
        final usuarioService = UsuarioService();
        final dados = await usuarioService.buscarUsuario(user.uid);

        if (dados != null && dados.tipoUsuario == 'administrador') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao entrar: $e')),
      );
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login (${widget.tipo})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CampoTexto(label: 'Email', controller: emailController),
            const SizedBox(height: 12),
            CampoTexto(label: 'Senha', controller: senhaController, senha: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: carregando ? null : _entrar,
                child: carregando
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Entrar'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastroPage())),
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
