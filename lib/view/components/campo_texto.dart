import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType tipo;
  final int? maxLines;
  final bool senha; 

  const CampoTexto({
    super.key,
    required this.controller,
    required this.label,
    this.tipo = TextInputType.text,
    this.maxLines = 1,
    this.senha = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: tipo,
        maxLines: maxLines,
        obscureText: senha, 
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

