import 'package:flutter/material.dart';
import 'package:integrador/service/auth_service.dart';
import 'package:integrador/view/login/perfil_page.dart';
import 'package:integrador/view/usuario/produtos_page.dart';
import 'package:integrador/view/usuario/eventos_page.dart';
import 'package:integrador/view/usuario/associacoes_page.dart';
import 'package:integrador/view/usuario/parcerias_page.dart';
import 'package:integrador/view/usuario/diretoria_page.dart';
import 'package:integrador/view/usuario/sobre_page.dart';
import 'package:integrador/view/login/login_page.dart';

import '../../components/botao_padrao.dart';
import '../../components/card_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) async {
    await AuthService().sair();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage(tipo: 'usuario')),
      (route) => false,
    );
  }

  Shader _gradienteTitulo() {
    return const LinearGradient(
      colors: [Color(0xFF0E2877), Color(0xFFE96120)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(const Rect.fromLTWH(0, 0, 250, 70));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cardsFirebase = [
      {
        "titulo": "Promoção Savanna",
        "descricao": "Aproveite 20% OFF nos produtos da atlética!",
      },
      {
        "titulo": "Eventos da Semana",
        "descricao": "Confira tudo o que vai rolar essa semana!",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f7),

      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f7),
        elevation: 0,
        title: Text(
          "Home",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            foreground: Paint()..shader = _gradienteTitulo(),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF0E2877),
              child: Icon(Icons.person, color: Colors.white),
            ),
            onSelected: (value) {
              if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilPage()),
                );
              } else if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'perfil', child: Text('Meu Perfil')),
              PopupMenuItem(value: 'logout', child: Text('Sair')),
            ],
          ),
        ],
      ),

      body: Stack(
        children: [
          Positioned(
            bottom: -100,
            left: -100,
            child: Image.asset("assets/imgs/mascote.png", width: 400),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    BotaoPadrao(
                      texto: "Produtos",
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProdutosPage()),
                      ),
                      cor: const Color(0xffE96120),
                      transparencia: 0.80,
                      altura: 25,
                    ),
                    BotaoPadrao(
                      texto: "Eventos",
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EventosPage()),
                      ),
                      cor: const Color(0xffE96120),
                      transparencia: 0.85,
                      altura: 25,
                    ),
                    BotaoPadrao(
                      texto: "Associações",
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AssociacoesPage(),
                        ),
                      ),
                      cor: const Color(0xffE96120),
                      transparencia: 0.85,
                      altura: 25,
                    ),
                    BotaoPadrao(
                      texto: "Parceiros",
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ParceriasPage(),
                        ),
                      ),
                      cor: const Color(0xffE96120),
                      transparencia: 0.85,
                      altura: 25,
                    ),
                    BotaoPadrao(
                      texto: "Diretoria",
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DiretoriaPage(),
                        ),
                      ),
                      cor: const Color(0xffE96120),
                      transparencia: 0.85,
                    ),
                    BotaoPadrao(
                      texto: "Sobre nós",
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SobrePage()),
                      ),
                      cor: const Color(0xffE96120),
                      transparencia: 0.85,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  "Eventos & Promoções",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = _gradienteTitulo(),
                  ),
                ),

                const SizedBox(height: 12),

                for (int i = 0; i < cardsFirebase.length; i++)
                  CardItem(
                    titulo: cardsFirebase[i]["titulo"],
                    descricao: cardsFirebase[i]["descricao"],
                    corFundo: i % 2 == 0
                        ? const Color(0xFF0E2877)
                        : const Color(0xFFE96120),

                    opacidade: 0.70,

                    onTap: () {},
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
