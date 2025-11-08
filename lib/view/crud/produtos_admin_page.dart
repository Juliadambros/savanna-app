import 'package:flutter/material.dart';
import 'package:integrador/service/produto_service.dart';
import 'package:integrador/view/crud/produto_form_page.dart';
import '../../models/produto_model.dart';


class ProdutosAdminPage extends StatefulWidget {
  const ProdutosAdminPage({super.key});

  @override
  State<ProdutosAdminPage> createState() => _ProdutosAdminPageState();
}

class _ProdutosAdminPageState extends State<ProdutosAdminPage> {
  final ProdutoService _service = ProdutoService();
  List<ProdutoModel> _produtos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    try {
      final lista = await _service.listarProdutos();
      setState(() => _produtos = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar produtos: $e')));
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _deletar(ProdutoModel p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir o produto "${p.nome}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await _service.produtos.doc(p.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto excluído')));
      await _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir produto: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProdutoFormPage()));
          await _carregar();
        },
        child: const Icon(Icons.add),
        tooltip: 'Novo produto',
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _produtos.isEmpty
                ? const Center(child: Text('Nenhum produto cadastrado'))
                : RefreshIndicator(
                    onRefresh: _carregar,
                    child: ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final p = _produtos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: p.imagemUrl.isNotEmpty
                                ? Image.network(p.imagemUrl, width: 56, height: 56, fit: BoxFit.cover)
                                : const Icon(Icons.shopping_bag),
                            title: Text(p.nome),
                            subtitle: Text('${p.categoria} • ${p.tamanho}'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'editar') {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ProdutoFormPage(produto: p)),
                                  );
                                  await _carregar();
                                } else if (value == 'deletar') {
                                  await _deletar(p);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'editar', child: Text('Editar')),
                                PopupMenuItem(value: 'deletar', child: Text('Excluir')),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
