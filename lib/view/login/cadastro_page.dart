import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/service/usuario_service.dart';
import 'package:integrador/components/campo_dropdown.dart';
import '../../models/usuario_model.dart';
import 'home_page.dart';
import '../../components/campo_texto.dart';
import 'escolha_tipo_usuario_page.dart';
import '../../components/botao_padrao.dart';

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

  final cursos = ['Ciência da Computação', 'Química', 'Física', 'Matemática Licenciatura', "Big Data", "Matematica Computacional"];

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
      final firebaseUser = await auth.cadastrar(
        email.text.trim(),
        senha.text.trim(),
      );

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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: $e')));
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f7),
        title: const Text('Cadastro'),
        // mesmo padrão da LoginPage: seta de voltar
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

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Image.asset("assets/imgs/logo.png", height: 120),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Cadastre-se já e obtenha todos os benefícios!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader =
                            const LinearGradient(
                              colors: [Color(0xFF0E2877), Color(0xFFE96120)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(
                              Rect.fromLTWH(
                                0,
                                0,
                                400,
                                70,
                              ), 
                            ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 50),

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

                  BotaoPadrao(
                    texto: carregando ? "Cadastrando..." : "Cadastrar",
                    onPressed: carregando ? () {} : _cadastrar,
                    cor: const Color(0xffE96120),
                    transparencia: 0.8,
                    tamanhoFonte: 14,
                    altura: 45,
                    largura: 200,
                    raioBorda: 20,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
