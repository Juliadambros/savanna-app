import 'package:flutter/material.dart';
import 'package:integrador/models/evento_model.dart';
import 'package:integrador/service/evento_service.dart';

class FormEvento extends StatefulWidget {
  final EventoModel? evento;
  const FormEvento({super.key, this.evento});

  @override
  State<FormEvento> createState() => _FormEventoState();
}

class _FormEventoState extends State<FormEvento> {
  final _formKey = GlobalKey<FormState>();
  final EventoService _service = EventoService();

  late TextEditingController _nomeController;
  late TextEditingController _localController;
  late TextEditingController _tipoController;
  late TextEditingController _descricaoController;
  DateTime? _dataSelecionada;

  @override
  void initState() {
    super.initState();
    final e = widget.evento;
    _nomeController = TextEditingController(text: e?.nome ?? '');
    _localController = TextEditingController(text: e?.local ?? '');
    _tipoController = TextEditingController(text: e?.tipo ?? '');
    _descricaoController = TextEditingController(text: e?.descricao ?? '');
    _dataSelecionada = e?.data;
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? hoje,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null) setState(() => _dataSelecionada = data);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate() || _dataSelecionada == null) return;

    final evento = EventoModel(
      id: widget.evento?.id,
      nome: _nomeController.text,
      local: _localController.text,
      tipo: _tipoController.text,
      descricao: _descricaoController.text,
      data: _dataSelecionada!,
    );

    await _service.salvar(evento);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.evento == null ? 'Novo Evento' : 'Editar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(labelText: 'Local'),
                validator: (v) => v!.isEmpty ? 'Informe o local' : null,
              ),
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (v) => v!.isEmpty ? 'Informe o tipo' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(_dataSelecionada == null
                      ? 'Nenhuma data selecionada'
                      : 'Data: ${_dataSelecionada!.toLocal().toString().split(' ')[0]}'),
                  const Spacer(),
                  TextButton(
                    onPressed: _selecionarData,
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

