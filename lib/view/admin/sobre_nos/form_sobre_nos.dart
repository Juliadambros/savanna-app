import 'package:flutter/material.dart';
import 'package:integrador/models/sobre_nos_model.dart';
import 'package:integrador/service/sobre_nos_service.dart';


class FormSobreNos extends StatefulWidget {
  final SobreNosModel? pagina;
  const FormSobreNos({super.key, this.pagina});

  @override
  State<FormSobreNos> createState() => _FormSobreNosState();
}

class _FormSobreNosState extends State<FormSobreNos> {
  final _formKey = GlobalKey<FormState>();
  final SobreNosService _service = SobreNosService();

  late TextEditingController _titulo;
  late TextEditingController _conteudo;

  @override
  void initState() {
    super.initState();
    final p = widget.pagina;
    _titulo = TextEditingController(text: p?.titulo ?? '');
    _conteudo = TextEditingController(text: p?.conteudo ?? '');
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final pagina = SobreNosModel(
      id: widget.pagina?.id,
      titulo: _titulo.text,
      conteudo: _conteudo.text,
    );

    await _service.salvar(pagina);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pagina == null ? 'Nova Página' : 'Editar Página'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titulo,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _conteudo,
                decoration: const InputDecoration(labelText: 'Conteúdo'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o conteúdo' : null,
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
