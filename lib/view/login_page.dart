import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/service/usuario_service.dart';
import 'home_page.dart';
import 'painel_admin_page.dart';
import 'cadastro_page.dart';
import 'components/campo_texto.dart';
import 'escolha_tipo_usuario_page.dart';

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
        final dados = await UsuarioService().buscarUsuario(user.uid);
        final isAdminLogin = widget.tipo.toLowerCase() == 'administrador';
        final isAdminUser = dados?.tipoUsuario.toLowerCase() == 'adm';

        if (isAdminLogin) {
          if (isAdminUser) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PainelAdminPage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Acesso negado: você não é administrador')),
            );
          }
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
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
    final isAdmin = widget.tipo.toLowerCase() == 'administrador';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Login Administrador' : 'Login Usuário'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const EscolhaTipoUsuarioPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CampoTexto(label: 'Email', controller: emailController),
            const SizedBox(height: 12),
            CampoTexto(label: 'Senha', controller: senhaController, senha: true),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidade ainda não implementada')),
                  );
                },
                child: const Text('Esqueceu sua senha?'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: carregando ? null : _entrar,
                child: carregando
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Entrar'),
              ),
            ),
            if (!isAdmin) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastroPage())),
                child: const Text('Criar conta'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
