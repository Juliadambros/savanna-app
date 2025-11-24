import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/service/usuario_service.dart';
import 'home_page.dart';
import 'painel_admin_page.dart';
import 'cadastro_page.dart';
import '../components/campo_texto.dart';
import '../components/botao_padrao.dart';
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PainelAdminPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Acesso negado: você não é administrador'),
              ),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao entrar: $e')));
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.tipo.toLowerCase() == 'administrador';

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f7),
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
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset("assets/imgs/mascote.png", fit: BoxFit.contain),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 60),

                Image.asset("assets/imgs/logo.png"),
                const SizedBox(height: 50),

                CampoTexto(label: 'Email', controller: emailController),
                const SizedBox(height: 10),

                CampoTexto(
                  controller: senhaController,
                  label: "Senha",
                  senha: true,
                  emojiFinal: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF0E2877),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Funcionalidade ainda não implementada',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: Color(0xFF0E2877)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                BotaoPadrao(
                  texto: carregando ? "Entrando..." : "Entrar",
                  onPressed: carregando ? () {} : _entrar,
                  cor: const Color(0xffE96120),
                  transparencia: 0.8,
                  tamanhoFonte: 12,
                  altura: 40,
                  largura: 200,
                  raioBorda: 20,
                ),

                if (!isAdmin) ...[
                  const SizedBox(height: 16),
                  BotaoPadrao(
                    texto: carregando ? "Criando conta..." : "Criar conta",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CadastroPage()),
                    ),
                    cor: const Color(0xffE96120),
                    transparencia: 0.8,
                    tamanhoFonte: 12,
                    altura: 40,
                    largura: 200,
                    raioBorda: 20,
                  ),
                ],

                const Spacer(), // empurra o fundo sem criar espaço lá em cima
              ],
            ),
          ),
        ],
      ),
    );
  }
}
