import 'package:flutter/material.dart';
import '../../service/pagina_service.dart';
import '../../models/pagina_model.dart';

class DiretoriaPage extends StatelessWidget {
  const DiretoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = PaginaService();

    return Scaffold(
      appBar: AppBar(title: const Text("Diretoria")),
      body: FutureBuilder<PaginaModel?>(
        future: service.buscar('diretoria'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final pagina = snapshot.data;
          final membros = List<Map<String, dynamic>>.from(
            pagina?.conteudo['membros'] ?? [],
          );

          if (membros.isEmpty) {
            return const Center(child: Text("Nenhum membro cadastrado."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: membros.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final m = membros[i];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: m['fotoUrl'] != null
                        ? NetworkImage(m['fotoUrl'])
                        : null,
                    child:
                        m['fotoUrl'] == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(
                    m['nome'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${m['cargo'] ?? ''}\n${m['curso'] ?? ''}'),
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

