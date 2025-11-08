import 'package:flutter/material.dart';
import 'package:integrador/service/produto_service.dart';
import 'package:integrador/service/whatsapp_service.dart';

import '../models/produto_model.dart';

import 'formulario_jersey_page.dart';

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: FutureBuilder<List<ProdutoModel>>(
        future: ProdutoService().listarProdutos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto disponível'));
          }

          final produtos = snapshot.data!;

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final p = produtos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: p.imagemUrl.isNotEmpty
                      ? Image.network(p.imagemUrl, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.shopping_bag),
                  title: Text(p.nome),
                  subtitle: Text('${p.categoria} • ${p.tamanho}'),
                  trailing: Text('R\$ ${p.preco.toStringAsFixed(2)}'),
                  onTap: () {
                    if (p.personalizado) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FormularioJerseyPage(produto: p)),
                      );
                    } else {
                      final mensagem = 'Olá, gostaria de comprar o produto: ${p.nome} (id: ${p.id})';
                      WhatsAppService.enviarMensagem('55DD999999999', mensagem);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
