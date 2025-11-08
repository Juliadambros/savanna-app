import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/service/usuario_service.dart';
import 'package:integrador/view/painel_admin_page.dart';
import 'produtos_page.dart';
import 'eventos_page.dart';
import 'associacoes_page.dart';
import 'parceiros_page.dart';
import 'perfil_page.dart';
import 'sobre_page.dart';
import 'diretoria_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _carregandoTipo = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _verificarAdmin();
  }

  Future<void> _verificarAdmin() async {
    setState(() => _carregandoTipo = true);
    try {
      final user = AuthService().usuarioAtual() ?? FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isAdmin = false;
        });
        return;
      }
      final dados = await UsuarioService().buscarUsuario(user.uid);
      final tipo = dados?.tipoUsuario?.toLowerCase() ?? '';
      setState(() => _isAdmin = tipo == 'administrador' || tipo == 'adm' || tipo.startsWith('adm'));
    } catch (e) {
      setState(() => _isAdmin = false);
    } finally {
      setState(() => _carregandoTipo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // menu simples com botões
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProdutosPage())),
            child: const Text('Produtos'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventosPage())),
            child: const Text('Eventos'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssociacoesPage())),
            child: const Text('Associações'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParceriasPage())),
            child: const Text('Parceiros'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiretoriaPage())),
            child: const Text('Diretoria'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilPage())),
            child: const Text('Perfil'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SobrePage())),
            child: const Text('Sobre nós'),
          ),

          const SizedBox(height: 20),
          // area do admin: aparece apenas se for administrador
          if (_carregandoTipo) ...[
            const Center(child: CircularProgressIndicator()),
          ] else if (_isAdmin) ...[
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PainelAdminPage())),
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Painel Administrativo'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
            ),
          ],
        ],
      ),
    );
  }
}
