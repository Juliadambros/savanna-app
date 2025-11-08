import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:integrador/service/associacao_service.dart';
import 'formulario_associacao_page.dart';

class AssociacoesPage extends StatefulWidget {
  const AssociacoesPage({super.key});

  @override
  State<AssociacoesPage> createState() => _AssociacoesPageState();
}

class _AssociacoesPageState extends State<AssociacoesPage> {
  final user = FirebaseAuth.instance.currentUser;
  final _service = AssociacaoService();
  bool carregando = true;
  bool associado = false;

  @override
  void initState() {
    super.initState();
    _verificarAssociacao();
  }

  Future<void> _verificarAssociacao() async {
    if (user == null) return;
    final lista = await _service.listarPorEmail(user!.email!);
    setState(() {
      associado = lista.isNotEmpty;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Associações")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: associado
            ? const Center(
                child: Text(
                  "Você já está associado!\nObrigado por fazer parte!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Associe-se à nossa entidade!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Aqui você pode se associar ou renovar sua associação. "
                    "Preencha o formulário e envie suas informações.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.assignment),
                      label: const Text("Associar / Reassociar"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14,
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FormularioAssociacaoPage(),
                          ),
                        );
                        _verificarAssociacao(); // atualiza status após voltar
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
