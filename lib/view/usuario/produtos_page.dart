import 'package:flutter/material.dart';
import 'package:integrador/models/produto_model.dart';
import 'package:integrador/service/produto_service.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final service = ProdutoService();
  List<ProdutoModel> produtos = [];

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    final lista = await service.listar();
    setState(() => produtos = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: produtos.isEmpty
          ? const Center(child: Text('Nenhum produto disponível.'))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final p = produtos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(p.nome),
                    subtitle: Text(p.descricao),
                    trailing:
                        Text('R\$ ${p.preco.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
    );
  }
}
