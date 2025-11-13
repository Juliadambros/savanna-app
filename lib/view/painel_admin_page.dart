import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/view/admin/associacao/adm_associacao.dart';
import 'package:integrador/view/admin/diretoria/adm_diretoria.dart';
import 'package:integrador/view/admin/evento/adm_eventos.dart';
import 'package:integrador/view/admin/parcerias/adm_parcerias.dart';
import 'package:integrador/view/admin/produto/adm_produtos.dart';
import 'package:integrador/view/admin/usuario/adm_usuario.dart';
import 'package:integrador/view/admin/sobre_nos/adm_sobre_nos.dart';
import 'package:integrador/view/login_page.dart';

class PainelAdminPage extends StatelessWidget {
  const PainelAdminPage({super.key});

  void _logout(BuildContext context) async {
    await AuthService().sair();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage(tipo: 'adm')),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person),
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Gerenciar Produtos'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmProdutosPage())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.event),
              label: const Text('Gerenciar Eventos'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmEventosPage())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Gerenciar Usuários'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UsuariosAdminPage())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.how_to_reg),
              label: const Text('Gerenciar Associações'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmAssociacoesPage())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.group),
              label: const Text('Gerenciar Diretoria'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmDiretoriaPage())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.handshake),
              label: const Text('Gerenciar Parcerias'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmParceriasPage())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.info),
              label: const Text('Gerenciar Sobre Nós'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdmSobreNosPage())),
            ),
          ],
        ),
      ),
    );
  }
}
