import 'package:flutter/material.dart';
import 'package:integrador/service/associacao_service.dart';
import '../../models/associacao_model.dart';
import '../components/campo_texto.dart';
import '../components/campo_dropdown.dart';

class AssociacaoFormPage extends StatefulWidget {
  final AssociacaoModel? associacao;
  const AssociacaoFormPage({super.key, this.associacao});

  @override
  State<AssociacaoFormPage> createState() => _AssociacaoFormPageState();
}

class _AssociacaoFormPageState extends State<AssociacaoFormPage> {
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final raCtrl = TextEditingController();

  String? curso;
  String? tipo;
  String? meioPagamento;

  bool salvando = false;

  final cursos = ['Computação', 'Engenharia', 'Direito', 'Administração'];
  final tipos = ['associacao', 'reassociacao'];
  final meios = ['PIX', 'Boleto', 'Dinheiro', 'Cartão'];

  final AssociacaoService _service = AssociacaoService();

  @override
  void initState() {
    super.initState();
    if (widget.associacao != null) {
      final a = widget.associacao!;
      nomeCtrl.text = a.nomeCompleto;
      emailCtrl.text = a.email;
      cpfCtrl.text = a.cpf;
      raCtrl.text = a.ra;
      curso = a.curso;
      tipo = a.tipo;
      meioPagamento = a.meioPagamento;
    }
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    cpfCtrl.dispose();
    raCtrl.dispose();
    super.dispose();
  }

  void _erro(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _salvar() async {
    final nome = nomeCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final cpf = cpfCtrl.text.trim();
    final ra = raCtrl.text.trim();

    if (nome.isEmpty) { _erro("Preencha o nome"); return; }
    if (email.isEmpty || !email.contains("@")) { _erro("Email inválido"); return; }
    if (cpf.isEmpty) { _erro("Preencha o CPF"); return; }
    if (ra.isEmpty) { _erro("Preencha o RA"); return; }
    if (curso == null) { _erro("Selecione o curso"); return; }
    if (tipo == null) { _erro("Selecione o tipo"); return; }
    if (meioPagamento == null) { _erro("Selecione o meio de pagamento"); return; }

    setState(() => salvando = true);

    try {
      final id = widget.associacao?.id 
          ?? DateTime.now().millisecondsSinceEpoch.toString();

      final nova = AssociacaoModel(
        id: id,
        nomeCompleto: nome,
        email: email,
        cpf: cpf,
        ra: ra,
        curso: curso!,
        tipo: tipo!,
        meioPagamento: meioPagamento!,
      );

      await _service.salvarAssociacao(nova);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Associação salva com sucesso'))
      );

      Navigator.pop(context);
    } catch (e) {
      _erro("Erro ao salvar: $e");
    } finally {
      setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.associacao == null
        ? "Nova Associação"
        : "Editar Associação";

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CampoTexto(label: "Nome completo", controller: nomeCtrl),
          const SizedBox(height: 8),

          CampoTexto(label: "Email", controller: emailCtrl),
          const SizedBox(height: 8),

          CampoTexto(label: "CPF", controller: cpfCtrl),
          const SizedBox(height: 8),

          CampoTexto(label: "RA", controller: raCtrl),
          const SizedBox(height: 8),

          CampoDropdown(
            label: "Curso",
            valor: curso,
            itens: cursos,
            aoMudar: (v) => setState(() => curso = v),
          ),
          const SizedBox(height: 8),

          CampoDropdown(
            label: "Tipo",
            valor: tipo,
            itens: tipos,
            aoMudar: (v) => setState(() => tipo = v),
          ),
          const SizedBox(height: 8),

          CampoDropdown(
            label: "Meio de pagamento",
            valor: meioPagamento,
            itens: meios,
            aoMudar: (v) => setState(() => meioPagamento = v),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: salvando ? null : _salvar,
            child: salvando
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Salvar"),
          ),
        ],
      ),
    );
  }
}
