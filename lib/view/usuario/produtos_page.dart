import 'package:flutter/material.dart';
import 'package:integrador/models/produto_model.dart';
import 'package:integrador/service/produto_service.dart';
import 'package:integrador/components/card_item.dart';

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.30,
              child: Image.asset('assets/imgs/mascote.png', fit: BoxFit.cover),
            ),
          ),

          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 20),
                child: Text(
                  "Produtos",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: produtos.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum produto disponível.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: produtos.length,
                        itemBuilder: (context, index) {
                          final p = produtos[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: CardItem(
                              titulo: p.nome,
                              descricao: p.descricao,
                              imagem: "assets/imgs/img3.png",
                              opacidade: 0.70,
                              corFundo: index % 2 == 0
                                  ? const Color(0xFF0E2877)
                                  : const Color(0xFFE96120),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
