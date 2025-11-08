import 'package:flutter/material.dart';
import 'package:integrador/service/produto_service.dart';
import '../../models/produto_model.dart';
import '../components/campo_texto.dart';
import '../components/campo_dropdown.dart';

class ProdutoFormPage extends StatefulWidget {
  final ProdutoModel? produto;
  const ProdutoFormPage({super.key, this.produto});

  @override
  State<ProdutoFormPage> createState() => _ProdutoFormPageState();
}

class _ProdutoFormPageState extends State<ProdutoFormPage> {
  final nome = TextEditingController();
  final preco = TextEditingController();
  final descricao = TextEditingController();
  final imagem = TextEditingController();

  String? categoria;
  String? tamanho;
  String? cor;
  bool personalizado = false;
  bool salvando = false;

  final categorias = ['Caneca', 'Jersey', 'Boné', 'Outro'];
  final tamanhos = ['PP', 'P', 'M', 'G', 'GG'];
  final cores = ['Vermelho', 'Preto', 'Branco', 'Azul'];

  final ProdutoService _service = ProdutoService();

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      final p = widget.produto!;
      nome.text = p.nome;
      preco.text = p.preco.toString();
      descricao.text = p.descricao;
      imagem.text = p.imagemUrl;
      categoria = p.categoria;
      tamanho = p.tamanho;
      cor = p.cor;
      personalizado = p.personalizado;
    }
  }

  @override
  void dispose() {
    nome.dispose();
    preco.dispose();
    descricao.dispose();
    imagem.dispose();
    super.dispose();
  }

  void _erro(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _salvar() async {
    if (nome.text.trim().isEmpty) { _erro('Preencha o nome'); return; }
    if (categoria == null || categoria!.isEmpty) { _erro('Selecione a categoria'); return; }
    final precoVal = double.tryParse(preco.text.replaceAll(',', '.')) ?? -1;
    if (preco.text.isEmpty || precoVal < 0) { _erro('Preço inválido'); return; }

    setState(() => salvando = true);
    try {
      final id = widget.produto?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final produto = ProdutoModel(
        id: id,
        nome: nome.text.trim(),
        categoria: categoria!,
        tamanho: tamanho ?? '',
        cor: cor ?? '',
        preco: precoVal,
        descricao: descricao.text.trim(),
        imagemUrl: imagem.text.trim(),
        personalizado: personalizado,
      );

      await _service.salvarProduto(produto);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto salvo com sucesso')));
      Navigator.pop(context);
    } catch (e) {
      _erro('Erro ao salvar: $e');
    } finally {
      setState(() => salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.produto == null ? 'Novo Produto' : 'Editar Produto';
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CampoTexto(label: 'Nome', controller: nome),
          const SizedBox(height: 8),
          CampoTexto(label: 'Preço (ex: 49.90)', controller: preco),
          const SizedBox(height: 8),
          CampoDropdown(label: 'Categoria', valor: categoria, itens: categorias, aoMudar: (v) => setState(() => categoria = v)),
          const SizedBox(height: 8),
          CampoDropdown(label: 'Tamanho (opcional)', valor: tamanho, itens: tamanhos, aoMudar: (v) => setState(() => tamanho = v)),
          const SizedBox(height: 8),
          CampoDropdown(label: 'Cor (opcional)', valor: cor, itens: cores, aoMudar: (v) => setState(() => cor = v)),
          SwitchListTile(
            title: const Text('Personalizado (exige nome/número)'),
            value: personalizado,
            onChanged: (v) => setState(() => personalizado = v),
          ),
          const SizedBox(height: 8),
          CampoTexto(label: 'Descrição', controller: descricao),
          const SizedBox(height: 8),
          CampoTexto(label: 'URL da imagem (opcional)', controller: imagem),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: salvando ? null : _salvar,
            child: salvando ? const CircularProgressIndicator(color: Colors.white) : const Text('Salvar Produto'),
          ),
        ],
      ),
    );
  }
}
