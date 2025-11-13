import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integrador/service/usuario_service.dart';
import '../models/usuario_model.dart';

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
      appBar: AppBar(title: const Text('Meu perfil')),
      body: FutureBuilder<UsuarioModel?>(
        future: UsuarioService().buscarUsuario(current.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Dados não encontrados'));
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                const SizedBox(height: 16),
                Text(user.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(user.email),
                const Divider(height: 32),
                Row(children: [const Icon(Icons.school), const SizedBox(width: 8), Text('Curso: ${user.curso}')]),
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.phone), const SizedBox(width: 8), Text('Telefone: ${user.telefone}')]),
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.tag), const SizedBox(width: 8), Text('Apelido: ${user.apelidoCalouro}')]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.verified_user),
                    const SizedBox(width: 8),
                    Text(
                      'Status: ${user.associado ? "Associado ✅" : "Não associado ❌"}',
                      style: TextStyle(
                        color: user.associado ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
