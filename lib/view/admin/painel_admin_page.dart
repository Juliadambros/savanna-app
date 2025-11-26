import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/view/admin/associacao/adm_associacao.dart';
import 'package:integrador/view/admin/diretoria/adm_diretoria.dart';
import 'package:integrador/view/admin/evento/adm_eventos.dart';
import 'package:integrador/view/admin/parcerias/adm_parcerias.dart';
import 'package:integrador/view/admin/produto/adm_produtos.dart';
import 'package:integrador/view/admin/usuario/adm_usuario.dart';
import 'package:integrador/view/admin/sobre_nos/adm_sobre_nos.dart';
import 'package:integrador/view/login/login_page.dart';
import '../../components/botao_padrao.dart';

class PainelAdminPage extends StatelessWidget {
  const PainelAdminPage({super.key});

  void _logout(BuildContext context) async {
    await AuthService().sair();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage(tipo: 'administrador')),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f7),
        elevation: 0,
        title: const Text(
          'Painel Administrativo',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person, color: Colors.black),
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

      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 10),

          // LOGO NO TOPO
          Center(
            child: Image.asset(
              "assets/imgs/logo.png",
              height: 120,
            ),
          ),

          const SizedBox(height: 30),

          BotaoPadrao(
            texto: "Gerenciar Produtos",
            icone: Icons.shopping_bag,
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdmProdutosPage())),
            cor: const Color(0xffE96120),
            transparencia: 0.9,
            altura: 55,
            raioBorda: 16,
          ),
          const SizedBox(height: 12),

          BotaoPadrao(
            texto: "Gerenciar Eventos",
            icone: Icons.event,
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdmEventosPage())),
            cor: const Color(0xffE96120),
            transparencia: 0.9,
            altura: 55,
            raioBorda: 16,
          ),
          const SizedBox(height: 12),

          BotaoPadrao(
            texto: "Gerenciar Usuários",
            icone: Icons.people,
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const UsuariosAdminPage())),
            cor: const Color(0xffE96120),
            transparencia: 0.9,
            altura: 55,
            raioBorda: 16,
          ),
          const SizedBox(height: 12),

          BotaoPadrao(
            texto: "Gerenciar Associações",
            icone: Icons.how_to_reg,
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdmAssociacoesPage())),
            cor: const Color(0xffE96120),
            transparencia: 0.9,
            altura: 55,
            raioBorda: 16,
          ),
          const SizedBox(height: 12),

          BotaoPadrao(
            texto: "Gerenciar Diretoria",
            icone: Icons.group,
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdmDiretoriaPage())),
            cor: const Color(0xffE96120),
            transparencia: 0.9,
            altura: 55,
            raioBorda: 16,
          ),
          const SizedBox(height: 12),

          BotaoPadrao(
            texto: "Gerenciar Parcerias",
            icone: Icons.handshake,
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdmParceriasPage())),
            cor: const Color(0xffE96120),
            transparencia: 0.9,
            altura: 55,
            raioBorda: 16,
          ),
          const SizedBox(height: 12),

          BotaoPadrao(
            texto: "Gerenciar Sobre Nós",
            icone: Icons.info,
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AdmSobreNosPage())),
            cor: const Color(0xffE96120),
            transparencia: 0.9,
            altura: 55,
            raioBorda: 16,
          ),
        ],
      ),
    );
  }
}
