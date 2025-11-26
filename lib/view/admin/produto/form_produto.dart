import 'package:flutter/material.dart';
import 'package:integrador/components/botao_padrao.dart';
import 'package:integrador/components/campo_texto.dart';
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

    try {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto salvo com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar produto.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.produto != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0E2877),
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEdicao ? 'Editar Produto' : 'Novo Produto',
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
                  isEdicao ? 'Editar Produto' : 'Novo Produto',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          CampoTexto(
                            controller: _nomeController,
                            label: "Nome",
                            hint: "Digite o nome do produto",
                            emojiFinal: const Icon(Icons.shopping_bag, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _descricaoController,
                            label: "Descrição",
                            hint: "Digite a descrição do produto",
                            emojiFinal: const Icon(Icons.description, color: Color(0xFF0E2877)),
                          ),
                          CampoTexto(
                            controller: _precoController,
                            label: "Preço",
                            hint: "Digite o preço do produto",
                            tipo: TextInputType.numberWithOptions(decimal: true),
                            emojiFinal: const Icon(Icons.attach_money, color: Color(0xFF0E2877)),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SwitchListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              title: const Text(
                                'Disponível',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: _disponivel,
                              onChanged: (v) => setState(() => _disponivel = v),
                            ),
                          ),
                          const SizedBox(height: 20),
                          BotaoPadrao(
                            texto: "Salvar",
                            icone: Icons.save,
                            cor: const Color(0xFF0E2877),
                            raioBorda: 20,
                            tamanhoFonte: 18,
                            onPressed: () => _salvar(),
                          ),
                          const SizedBox(height: 10),
                          BotaoPadrao(
                            texto: "Salvar e Adicionar Outro",
                            icone: Icons.add,
                            cor: const Color(0xFF0E2877),
                            raioBorda: 20,
                            tamanhoFonte: 16,
                            onPressed: () => _salvar(novo: true),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
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