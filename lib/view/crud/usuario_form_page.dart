import 'package:flutter/material.dart';
import 'package:integrador/service/usuario_service.dart';
import '../../models/usuario_model.dart';

import '../components/campo_texto.dart';
import '../components/campo_dropdown.dart';

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

  void _erro(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _salvar() async {
    final nome = nomeCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final data = dataCtrl.text.trim();
    final telefone = telefoneCtrl.text.trim();
    final apelido = apelidoCtrl.text.trim();

    if (nome.isEmpty) { _erro('Preencha o nome'); return; }
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) { _erro('Email inválido'); return; }
    if (curso == null || curso!.isEmpty) { _erro('Selecione o curso'); return; }
    if (tipoUsuario == null || tipoUsuario!.isEmpty) { _erro('Selecione o tipo de usuário'); return; }

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

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário salvo com sucesso')));
      Navigator.pop(context);
    } catch (e) {
      _erro('Erro ao salvar usuário: $e');
    } finally {
      setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.usuario == null ? 'Novo Usuário' : 'Editar Usuário';
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CampoTexto(label: 'Nome', controller: nomeCtrl),
          const SizedBox(height: 8),
          CampoTexto(label: 'Email', controller: emailCtrl),
          const SizedBox(height: 8),
          CampoTexto(label: 'Data de nascimento', controller: dataCtrl),
          const SizedBox(height: 8),
          CampoTexto(label: 'Telefone', controller: telefoneCtrl),
          const SizedBox(height: 8),
          CampoTexto(label: 'Apelido de calouro', controller: apelidoCtrl),
          const SizedBox(height: 8),
          CampoDropdown(label: 'Curso', valor: curso, itens: cursos, aoMudar: (v) => setState(() => curso = v)),
          const SizedBox(height: 8),
          CampoDropdown(label: 'Tipo de usuário', valor: tipoUsuario, itens: tipos, aoMudar: (v) => setState(() => tipoUsuario = v)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: salvando ? null : _salvar,
            child: salvando ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
