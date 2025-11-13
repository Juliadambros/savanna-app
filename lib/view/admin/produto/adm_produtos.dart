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

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final produtos = await _service.listar();
    setState(() => _produtos = produtos);
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
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmar == true) {
      await _service.deletar(id);
      _carregarProdutos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Produtos')),
      body: _produtos.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado.'))
          : ListView.builder(
              itemCount: _produtos.length,
              itemBuilder: (context, i) {
                final p = _produtos[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      p.nome,
                      style: TextStyle(
                        color: p.disponivel ? Colors.black : Colors.grey,
                        decoration: p.disponivel ? null : TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text('${p.descricao}\nR\$ ${p.preco.toStringAsFixed(2)}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _remover(p.id!),
                    ),
                    onTap: () => _abrirFormulario(produto: p),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
