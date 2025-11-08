import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:integrador/service/associacao_service.dart';
import 'package:integrador/view/components/campo_dropdown.dart';
import 'package:integrador/view/components/campo_texto.dart';
import '../../models/associacao_model.dart';

class FormularioAssociacaoPage extends StatefulWidget {
  const FormularioAssociacaoPage({super.key});

  @override
  State<FormularioAssociacaoPage> createState() =>
      _FormularioAssociacaoPageState();
}

class _FormularioAssociacaoPageState extends State<FormularioAssociacaoPage> {
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final raCtrl = TextEditingController();

  String? curso;
  String? tipo;
  String? meioPagamento;
  bool enviando = false;

  final cursos = ['Computação', 'Engenharia', 'Direito', 'Administração'];
  final tipos = ['Associação', 'Reassociação'];
  final meios = ['PIX', 'Boleto', 'Dinheiro', 'Cartão'];

  final _service = AssociacaoService();

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> _enviar() async {
    final nome = nomeCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final cpf = cpfCtrl.text.trim();
    final ra = raCtrl.text.trim();

    if (nome.isEmpty ||
        email.isEmpty ||
        cpf.isEmpty ||
        ra.isEmpty ||
        curso == null ||
        tipo == null ||
        meioPagamento == null) {
      _mostrarErro("Preencha todos os campos!");
      return;
    }

    setState(() => enviando = true);

    try {
      final id = const Uuid().v4();

      final associacao = AssociacaoModel(
        id: id,
        nomeCompleto: nome,
        email: email,
        cpf: cpf,
        ra: ra,
        curso: curso!,
        tipo: tipo!,
        meioPagamento: meioPagamento!,
      );

      // 🔹 Agora o service cuida de tudo (salvar + WhatsApp)
      await _service.salvarAssociacao(associacao);
      await _service.enviarParaWhatsApp(associacao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Formulário enviado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _mostrarErro("Erro ao enviar formulário: $e");
    } finally {
      setState(() => enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulário de Associação"),
        centerTitle: true,
      ),
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
            label: "Tipo de Solicitação",
            valor: tipo,
            itens: tipos,
            aoMudar: (v) => setState(() => tipo = v),
          ),
          const SizedBox(height: 8),
          CampoDropdown(
            label: "Meio de Pagamento",
            valor: meioPagamento,
            itens: meios,
            aoMudar: (v) => setState(() => meioPagamento = v),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: enviando ? null : _enviar,
            icon: enviando
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: Text(enviando ? "Enviando..." : "Enviar"),
          ),
        ],
      ),
    );
  }
}

