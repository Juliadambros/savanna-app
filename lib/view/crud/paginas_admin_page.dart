import 'package:flutter/material.dart';
import 'editar_pagina_page.dart';

class PaginasAdminPage extends StatelessWidget {
  const PaginasAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paginas = [
      {'id': 'sobre_nos', 'nome': 'Sobre nós'},
      {'id': 'diretoria', 'nome': 'Diretoria'},
      {'id': 'parcerias', 'nome': 'Parcerias'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Gerenciar Páginas")),
      body: ListView(
        children: paginas.map((p) {
          return ListTile(
            leading: const Icon(Icons.description),
            title: Text(p['nome']!),
            trailing: const Icon(Icons.edit),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditarPaginaPage(id: p['id']!),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

