import 'package:flutter/material.dart';

import 'crud/produtos_admin_page.dart';
import 'crud/eventos_admin_page.dart';
import 'crud/usuarios_admin_page.dart';
import 'crud/associacoes_admin_page.dart';
import 'crud/paginas_admin_page.dart';

class PainelAdminPage extends StatelessWidget {
  const PainelAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel Administrativo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // PRODUTOS
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Gerenciar Produtos'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProdutosAdminPage()),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.event),
              label: const Text('Gerenciar Eventos'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventosAdminPage()),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Gerenciar Usuários'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsuariosAdminPage()),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.how_to_reg),
              label: const Text('Gerenciar Associações'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AssociacoesAdminPage()),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.description),
              label: const Text('Gerenciar Páginas'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaginasAdminPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

