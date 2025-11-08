import 'package:flutter/material.dart';

class BotaoPrincipal extends StatelessWidget {
  final String texto;
  final Function() aoPressionar;

  const BotaoPrincipal({
    super.key,
    required this.texto,
    required this.aoPressionar,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: aoPressionar,
        child: Text(texto),
      ),
    );
  }
}
