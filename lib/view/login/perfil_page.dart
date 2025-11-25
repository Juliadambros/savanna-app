import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integrador/service/usuario_service.dart';
import '../../models/usuario_model.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final current = FirebaseAuth.instance.currentUser;

    if (current == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meu perfil')),
        body: const Center(child: Text('Usuário não autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          // ---- Mascote no fundo ----
          Positioned.fill(
            child: Opacity(
              opacity: 0.30,
              child: Image.asset(
                'assets/imgs/mascote.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          FutureBuilder<UsuarioModel?>(
            future: UsuarioService().buscarUsuario(current.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Dados não encontrados'));
              }

              final user = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // ---- Avatar ----
                      const CircleAvatar(
                        radius: 55,
                        child: Icon(Icons.person, size: 60),
                      ),

                      const SizedBox(height: 20),

                      // ---------- CARD DO NOME ----------
                      _infoCard(user.nome),

                      // ---------- CARD DO NASCIMENTO ----------
                      _infoCard("Data de Nascimento: ${user.dataNascimento ?? '---'}"),

                      // ---------- CARD DO EMAIL ----------
                      _infoCard(user.email),

                      // ---------- CARD DO APELIDO ----------
                      _infoCard("Apelido: ${user.apelidoCalouro}"),

                      const SizedBox(height: 20),

                      // ---------- STATUS ----------
                      Text(
                        user.associado ? "Associado ✔️" : "Não Associado ❌",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: user.associado ? Colors.green : Colors.red,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ---- Botão editar ----
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Editar dados",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


 Widget _infoCard(String text) {
  return Container(
    width: double.infinity,
    height: 38, 
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: Color(0xFF3E4A88),
        width: 1.6,
      ),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

}
