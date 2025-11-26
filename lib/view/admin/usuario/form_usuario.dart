import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_dropdown.dart';
import 'package:integrador/components/campo_texto.dart';
import 'package:integrador/models/usuario_model.dart';
import 'package:integrador/service/usuario_service.dart';

class UsuarioFormPage extends StatefulWidget {
  final UsuarioModel? usuario;
  const UsuarioFormPage({super.key, this.usuario});

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dataCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final apelidoCtrl = TextEditingController();
  String? curso;
  String? tipoUsuario;
  bool salvando = false;

  final cursos = ['Computação', 'Engenharia', 'Direito', 'Administração'];
  final tipos = ['usuario', 'administrador'];

  final UsuarioService _service = UsuarioService();

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      final u = widget.usuario!;
      nomeCtrl.text = u.nome;
      emailCtrl.text = u.email;
      dataCtrl.text = u.dataNascimento;
      telefoneCtrl.text = u.telefone;
      apelidoCtrl.text = u.apelidoCalouro;
      curso = u.curso;
      tipoUsuario = u.tipoUsuario;
    } else {
      tipoUsuario = 'usuario';
    }
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    dataCtrl.dispose();
    telefoneCtrl.dispose();
    apelidoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final nome = nomeCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final data = dataCtrl.text.trim();
    final telefone = telefoneCtrl.text.trim();
    final apelido = apelidoCtrl.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o nome')),
      );
      return;
    }
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email inválido')),
      );
      return;
    }
    if (curso == null || curso!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o curso')),
      );
      return;
    }
    if (tipoUsuario == null || tipoUsuario!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o tipo de usuário')),
      );
      return;
    }

    setState(() => salvando = true);
    try {
      final id = widget.usuario?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();

      final usuario = UsuarioModel(
        uid: id,
        nome: nome,
        email: email,
        dataNascimento: data,
        telefone: telefone,
        apelidoCalouro: apelido,
        curso: curso!,
        tipoUsuario: tipoUsuario!,
      );

      await _service.salvarUsuario(usuario);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário salvo com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar usuário.')),
      );
    } finally {
      setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.usuario != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0E2877),
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEdicao ? 'Editar Usuário' : 'Novo Usuário',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E2877),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.13,
              child: Image.asset(
                'assets/imgs/mascote.png',
                width: 220,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Image.asset(
                    "assets/imgs/logo.png",
                    height: 70,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isEdicao ? 'Editar Usuário' : 'Novo Usuário',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        CampoTexto(
                          controller: nomeCtrl,
                          label: "Nome",
                          hint: "Digite o nome completo",
                          emojiFinal: const Icon(Icons.person, color: Color(0xFF0E2877)),
                        ),
                        CampoTexto(
                          controller: emailCtrl,
                          label: "Email",
                          hint: "Digite o email",
                          emojiFinal: const Icon(Icons.email, color: Color(0xFF0E2877)),
                        ),
                        CampoTexto(
                          controller: dataCtrl,
                          label: "Data de Nascimento",
                          hint: "Digite a data de nascimento",
                          emojiFinal: const Icon(Icons.calendar_today, color: Color(0xFF0E2877)),
                        ),
                        CampoTexto(
                          controller: telefoneCtrl,
                          label: "Telefone",
                          hint: "Digite o telefone",
                          emojiFinal: const Icon(Icons.phone, color: Color(0xFF0E2877)),
                        ),
                        CampoTexto(
                          controller: apelidoCtrl,
                          label: "Apelido de Calouro",
                          hint: "Digite o apelido",
                          emojiFinal: const Icon(Icons.emoji_emotions, color: Color(0xFF0E2877)),
                        ),
                        CampoDropdown(
                          label: "Curso",
                          valor: curso,
                          itens: cursos,
                          aoMudar: (v) => setState(() => curso = v),
                        ),
                        CampoDropdown(
                          label: "Tipo de Usuário",
                          valor: tipoUsuario,
                          itens: tipos,
                          aoMudar: (v) => setState(() => tipoUsuario = v),
                        ),
                        const SizedBox(height: 20),
                        BotaoPadrao(
                          texto: "Salvar",
                          icone: Icons.save,
                          cor: const Color(0xFF0E2877),
                          raioBorda: 20,
                          tamanhoFonte: 18,
                          onPressed: ()=>salvando ? null : _salvar,
               
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}