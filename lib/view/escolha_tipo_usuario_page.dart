import 'package:flutter/material.dart';
import 'login_page.dart';

class EscolhaTipoUsuarioPage extends StatelessWidget {
  const EscolhaTipoUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Entrar como")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage(tipo: "usuario"))),
              child: Text("Usuário"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage(tipo: "administrador"))),
              child: Text("Administrador"),
            ),
          ],
        ),
      ),
    );
  }
}
