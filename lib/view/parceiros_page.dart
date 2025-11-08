import 'package:flutter/material.dart';
import '../../service/pagina_service.dart';
import '../../models/pagina_model.dart';

class ParceriasPage extends StatelessWidget {
  const ParceriasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = PaginaService();

    return Scaffold(
      appBar: AppBar(title: const Text("Parcerias")),
      body: FutureBuilder<PaginaModel?>(
        future: service.buscar('parcerias'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final pagina = snapshot.data;
          final parceiros = List<Map<String, dynamic>>.from(
            pagina?.conteudo['parceiros'] ?? [],
          );

          if (parceiros.isEmpty) {
            return const Center(child: Text("Nenhuma parceria cadastrada."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: parceiros.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = parceiros[i];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: p['logoUrl'] != null
                      ? Image.network(p['logoUrl'],
                          width: 56, height: 56, fit: BoxFit.cover)
                      : const Icon(Icons.store, size: 40),
                  title: Text(
                    p['nome'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${p['descricao'] ?? ''}\nBenefícios: ${p['beneficios'] ?? ''}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

