import 'package:flutter/material.dart';
import 'login_page.dart';

class EscolhaTipoUsuarioPage extends StatelessWidget {
  const EscolhaTipoUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f7),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),

      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              "assets/imgs/mascote.png",
              fit: BoxFit.contain,
              width: 180,
            ),
          ),


          Column(
              children: [
                const SizedBox(height: 200),
                Center(
                  child: Image.asset("assets/imgs/logo.png", height: 120),
                ),
          
          
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF0E2877),
                      Color(0xFFE96120),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width * 1.2, bounds.height),
                  ),
                  child: const Text(
                    "Entrar como",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                ),
          
                const SizedBox(height: 40),
          
                _botaoPrincipal(
                  texto: "Usuário",
                  aoPressionar: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage(tipo: "usuario")),
                    );
                  },
                ),
          
                const SizedBox(height: 20),
          
                _botaoPrincipal(
                  texto: "Administrador",
                  aoPressionar: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage(tipo: "administrador")),
                    );
                  },
                ),
              ],
            ),
        ],),
    
    );
  }


  Widget _botaoPrincipal({
    required String texto,
    required VoidCallback aoPressionar,
  }) {
    return SizedBox(
      width: 230,
      height: 50,
      child: ElevatedButton(
        onPressed: aoPressionar,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xffE96120),
          foregroundColor: Colors.white,
          elevation: 3,
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
