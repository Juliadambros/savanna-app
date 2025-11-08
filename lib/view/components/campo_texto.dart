import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool senha;

  const CampoTexto({
    super.key,
    required this.label,
    required this.controller,
    this.senha = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: senha,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
