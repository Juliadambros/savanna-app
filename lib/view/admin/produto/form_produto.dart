import 'package:flutter/material.dart';
import 'package:integrador/models/produto_model.dart';
import 'package:integrador/service/produto_service.dart';

class FormProduto extends StatefulWidget {
  final ProdutoModel? produto;
  const FormProduto({super.key, this.produto});

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _formKey = GlobalKey<FormState>();
  final ProdutoService _service = ProdutoService();

  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _precoController;
  bool _disponivel = true;

  @override
  void initState() {
    super.initState();
    final p = widget.produto;
    _nomeController = TextEditingController(text: p?.nome ?? '');
    _descricaoController = TextEditingController(text: p?.descricao ?? '');
    _precoController = TextEditingController(
        text: p != null ? p.preco.toStringAsFixed(2) : '');
    _disponivel = p?.disponivel ?? true;
  }

  Future<void> _salvar({bool novo = false}) async {
    if (!_formKey.currentState!.validate()) return;

    final produto = ProdutoModel(
      id: widget.produto?.id,
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      preco: double.tryParse(_precoController.text) ?? 0.0,
      disponivel: _disponivel,
    );

    await _service.salvar(produto);

    if (novo) {
      _nomeController.clear();
      _descricaoController.clear();
      _precoController.clear();
      setState(() => _disponivel = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto salvo. Adicione outro!')),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto == null ? 'Novo Produto' : 'Editar Produto'),
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
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _precoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o preço' : null,
              ),
              SwitchListTile(
                title: const Text('Disponível'),
                value: _disponivel,
                onChanged: (v) => setState(() => _disponivel = v),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _salvar(),
                      child: const Text('Salvar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _salvar(novo: true),
                      child: const Text('Salvar e adicionar outro'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
