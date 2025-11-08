import 'package:flutter/material.dart';
import 'package:integrador/service/pagina_service.dart';
import '../../models/pagina_model.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = PaginaService();

    return Scaffold(
      appBar: AppBar(title: const Text("Sobre nós")),
      body: FutureBuilder<PaginaModel?>(
        future: service.buscar('sobre_nos'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final pagina = snapshot.data;
          if (pagina == null) {
            return const Center(child: Text("Página ainda não configurada."));
          }

          final texto = pagina.conteudo['texto'] ?? '';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              texto,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          );
        },
      ),
    );
  }
}
