import 'package:flutter/material.dart';
import 'package:integrador/models/diretor_model.dart';
import 'package:integrador/service/diretoria_service.dart';

class FormDiretor extends StatefulWidget {
  final DiretorModel? diretor;
  const FormDiretor({super.key, this.diretor});

  @override
  State<FormDiretor> createState() => _FormDiretorState();
}

class _FormDiretorState extends State<FormDiretor> {
  final _formKey = GlobalKey<FormState>();
  final DiretoriaService _service = DiretoriaService();

  late TextEditingController _nomeController;
  String? _cargoSelecionado;
  String? _cursoSelecionado;

  final List<String> cargos = [
    'Presidente',
    'Vice-Presidente',
    'Tesoureiro',
    'Secretário',
    'Membro'
  ];

  final List<String> cursos = [
    'Administração',
    'Engenharia',
    'Ciência da Computação',
    'Direito',
    'Arquitetura',
    'Outro'
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.diretor;
    _nomeController = TextEditingController(text: d?.nome ?? '');
    _cargoSelecionado = d?.cargo ?? cargos.first;
    _cursoSelecionado = d?.curso ?? cursos.first;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final diretor = DiretorModel(
      id: widget.diretor?.id,
      nome: _nomeController.text.trim(),
      cargo: _cargoSelecionado!,
      curso: _cursoSelecionado!,
    );

    try {
      await _service.salvarDiretor(diretor);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membro salvo com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diretor == null ? 'Novo Diretor' : 'Editar Diretor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _cargoSelecionado,
                decoration: const InputDecoration(labelText: 'Cargo'),
                items: cargos
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _cargoSelecionado = v),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Selecione o cargo' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _cursoSelecionado,
                decoration: const InputDecoration(labelText: 'Curso'),
                items: cursos
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _cursoSelecionado = v),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Selecione o curso' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
