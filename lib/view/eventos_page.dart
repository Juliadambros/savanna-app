import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/evento_model.dart';

class EventosPage extends StatelessWidget {
  const EventosPage({super.key});

  void _enviarWhatsApp(EventoModel evento) async {
    final mensagem =
        "Olá! Quero me inscrever no evento:\n"
        "🎉 *${evento.titulo}*\n"
        "📅 Data: ${evento.data}\n"
        "📍 Local: ${evento.local}\n"
        "💰 Preço: R\$ ${evento.preco}\n";

    final url = Uri.parse(
      "https://wa.me/5551999999999?text=${Uri.encodeComponent(mensagem)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Festas e Eventos")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('eventos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum evento disponível"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final evento = EventoModel.fromMap(data);

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(evento.titulo),
                  subtitle: Text("${evento.data} • ${evento.local}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.message, color: Colors.green),
                    onPressed: () => _enviarWhatsApp(evento),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

