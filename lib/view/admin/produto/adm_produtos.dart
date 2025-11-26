import 'package:flutter/material.dart';
import 'package:integrador/models/produto_model.dart';
import 'package:integrador/service/produto_service.dart';
import 'form_produto.dart';

class AdmProdutosPage extends StatefulWidget {
  const AdmProdutosPage({super.key});

  @override
  State<AdmProdutosPage> createState() => _AdmProdutosPageState();
}

class _AdmProdutosPageState extends State<AdmProdutosPage> {
  final ProdutoService _service = ProdutoService();
  List<ProdutoModel> _produtos = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final produtos = await _service.listar();
      setState(() => _produtos = produtos);
    } catch (e) {
      setState(() => _erro = 'Erro ao carregar produtos.');
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _abrirFormulario({ProdutoModel? produto}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormProduto(produto: produto)),
    );
    _carregarProdutos();
  }

  Future<void> _remover(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente remover este produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _service.deletar(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto removido com sucesso!')),
        );
        _carregarProdutos();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao remover produto.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0E2877),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Produtos",
          style: TextStyle(
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
                const Text(
                  "Gerenciar Produtos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : _erro != null
                          ? Center(child: Text(_erro!))
                          : _produtos.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum produto cadastrado.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _produtos.length,
                                  itemBuilder: (context, i) {
                                    final p = _produtos[i];
                                    return Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(16),
                                        title: Text(
                                          p.nome,
                                          style: TextStyle(
                                            color: p.disponivel
                                                ? Colors.black
                                                : Colors.grey,
                                            decoration: p.disponivel
                                                ? null
                                                : TextDecoration.lineThrough,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${p.descricao}\nPreço: R\$ ${p.preco.toStringAsFixed(2)}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        isThreeLine: true,
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () => _remover(p.id!),
                                        ),
                                        onTap: () =>
                                            _abrirFormulario(produto: p),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0E2877),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _abrirFormulario(),
      ),
    );
  }
}