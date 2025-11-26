import 'package:flutter/material.dart';
import 'package:integrador/models/associacao_model.dart';
import 'package:integrador/service/associacao_service.dart';
import 'package:integrador/service/whatsapp_service.dart';
import 'package:uuid/uuid.dart';

class FormAssociacao extends StatefulWidget {
  final AssociacaoModel? associacao;

  const FormAssociacao({super.key, this.associacao});

  @override
  State<FormAssociacao> createState() => _FormAssociacaoState();
}

class _FormAssociacaoState extends State<FormAssociacao> {
  final _formKey = GlobalKey<FormState>();
  final _service = AssociacaoService();
  final _uuid = const Uuid();

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _raController;
  late TextEditingController _telefoneController;

  String? _tipoSelecionado;
  String? _cursoSelecionado;
  String? _pagamentoSelecionado;

  final List<String> tipos = ['Aluno', 'Ex-aluno', 'Outro'];
  final List<String> cursos = ['ADS', 'Engenharia', 'Design', 'Computação', 'Outro'];
  final List<String> pagamentos = ['Pix', 'Cartão', 'Boleto', 'Outro'];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.associacao?.nomeCompleto ?? '');
    _emailController = TextEditingController(text: widget.associacao?.email ?? '');
    _cpfController = TextEditingController(text: widget.associacao?.cpf ?? '');
    _raController = TextEditingController(text: widget.associacao?.ra ?? '');
    _telefoneController = TextEditingController(text: widget.associacao?.telefone ?? '');
    _tipoSelecionado = widget.associacao?.tipo;
    _cursoSelecionado = widget.associacao?.curso;
    _pagamentoSelecionado = widget.associacao?.meioPagamento;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final novaAssociacao = AssociacaoModel(
      id: widget.associacao?.id ?? _uuid.v4(),
      nomeCompleto: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      cpf: _cpfController.text.trim(),
      ra: _raController.text.trim(),
      curso: _cursoSelecionado ?? '',
      tipo: _tipoSelecionado ?? '',
      meioPagamento: _pagamentoSelecionado ?? '',
      telefone: _telefoneController.text.trim(),
      status: 'pendente',
    );

    try {
      await _service.salvarAssociacao(novaAssociacao);

      const numeroAdm = '+55XXXXXXXXXX'; // substitir
      final mensagem = '''
 *Nova Solicitação de Associação*

 Nome: ${novaAssociacao.nomeCompleto}
 E-mail: ${novaAssociacao.email}
 CPF: ${novaAssociacao.cpf}
 RA: ${novaAssociacao.ra}
 Curso: ${novaAssociacao.curso}
 Pagamento: ${novaAssociacao.meioPagamento}
 Telefone: ${novaAssociacao.telefone}

 Acesse o painel administrativo para aprovar ou recusar.
''';
      await WhatsAppService.enviarMensagem(numeroAdm, mensagem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitação enviada com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _raController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitação de Associação')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo'),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) => v!.isEmpty ? 'Informe o e-mail' : null,
              ),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (v) => v!.isEmpty ? 'Informe o CPF' : null,
              ),
              TextFormField(
                controller: _raController,
                decoration: const InputDecoration(labelText: 'RA'),
                validator: (v) => v!.isEmpty ? 'Informe o RA' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone (com DDD)'),
                validator: (v) => v!.isEmpty ? 'Informe o telefone' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoSelecionado,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _tipoSelecionado = v),
                validator: (v) => v == null ? 'Selecione o tipo' : null,
              ),
              DropdownButtonFormField<String>(
                value: _cursoSelecionado,
                decoration: const InputDecoration(labelText: 'Curso'),
                items: cursos.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _cursoSelecionado = v),
                validator: (v) => v == null ? 'Selecione o curso' : null,
              ),
              DropdownButtonFormField<String>(
                value: _pagamentoSelecionado,
                decoration: const InputDecoration(labelText: 'Meio de Pagamento'),
                items: pagamentos.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (v) => setState(() => _pagamentoSelecionado = v),
                validator: (v) => v == null ? 'Selecione o pagamento' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Enviar Solicitação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
