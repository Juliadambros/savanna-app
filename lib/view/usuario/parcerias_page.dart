import 'package:flutter/material.dart';
import 'package:integrador/models/parceiro_model.dart';
import 'package:integrador/service/parceiro_service.dart';
import 'package:integrador/components/card_item.dart';

class ParceriasPage extends StatefulWidget {
  const ParceriasPage({super.key});

  @override
  State<ParceriasPage> createState() => _ParceriasPageState();
}

class _ParceriasPageState extends State<ParceriasPage> {
  final service = ParceiroService();
  List<ParceiroModel> parceiros = [];

  @override
  void initState() {
    super.initState();
    carregarParcerias();
  }

  Future<void> carregarParcerias() async {
    final lista = await service.listar();
    setState(() => parceiros = lista);
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
              child: Image.asset(
                'assets/imgs/mascote.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 20),
                child: Text(
                  "Parcerias",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              Expanded(
                child: parceiros.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma parceria cadastrada.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: parceiros.length,
                        itemBuilder: (context, index) {
                          final p = parceiros[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CardItem(
                              titulo: p.nome,
                              descricao:
                                  "${p.descricao}\nContato: ${p.contato}",
             
                              opacidade: 0.70,
                              corFundo: index % 2 == 0
                                  ? const Color(0xFF0E2877)
                                  : const Color(0xFFE96120),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
