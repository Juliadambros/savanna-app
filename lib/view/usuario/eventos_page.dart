import 'package:flutter/material.dart';
import 'package:integrador/models/evento_model.dart';
import 'package:integrador/service/evento_service.dart';
import 'package:integrador/components/card_item.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final service = EventoService();
  List<EventoModel> eventos = [];

  @override
  void initState() {
    super.initState();
    carregarEventos();
  }

  Future<void> carregarEventos() async {
    final lista = await service.listar();
    setState(() => eventos = lista);
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
              opacity: 0.12,
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
                  "Eventos",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: eventos.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum evento disponível.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: eventos.length,
                        itemBuilder: (context, index) {
                          final e = eventos[index];

                          // Alternância de cores igual produtos
                          final Color corCard = index % 2 == 0
                               ?const Color(0xFF0E2877)
                                  : const Color(0xFFE96120);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: CardItem(
                              titulo: e.nome,
                              descricao:
                                  "${e.tipo} • ${e.local}\n${e.data.toLocal().toString().split(' ')[0]}",

                     

                              corFundo: corCard,
                              opacidade: 0.70,
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
