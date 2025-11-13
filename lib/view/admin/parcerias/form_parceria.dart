import 'package:flutter/material.dart';
import 'package:integrador/models/parceiro_model.dart';
import 'package:integrador/service/parceiro_service.dart';

class FormParceria extends StatefulWidget {
  final ParceiroModel? parceiro;
  const FormParceria({super.key, this.parceiro});

  @override
  State<FormParceria> createState() => _FormParceriaState();
}

class _FormParceriaState extends State<FormParceria> {
  final _formKey = GlobalKey<FormState>();
  final ParceiroService _service = ParceiroService();

  late TextEditingController _nome;
  late TextEditingController _descricao;
  late TextEditingController _contato; 

  @override
  void initState() {
    super.initState();
    final p = widget.parceiro;
    _nome = TextEditingController(text: p?.nome ?? '');
    _descricao = TextEditingController(text: p?.descricao ?? '');
    _contato = TextEditingController(text: p?.contato ?? '');
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final parceiro = ParceiroModel(
      id: widget.parceiro?.id,
      nome: _nome.text,
      descricao: _descricao.text,
      contato: _contato.text,
    );

    await _service.salvar(parceiro);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.parceiro == null ? 'Nova Parceria' : 'Editar Parceria')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nome,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _descricao,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a descrição' : null,
              ),
              TextFormField(
                controller: _contato,
                decoration: const InputDecoration(labelText: 'Contato'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o contato' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}


