import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType tipo;
  final int? maxLines;
  final bool senha;
  final String? hint;               
  final Widget? emojiFinal;         
  final Color corBorda;             
  final Color corTexto;             
  final Color corLabel;             
  final Function(String)? onChanged; 

  const CampoTexto({
    super.key,
    required this.controller,
    required this.label,
    this.tipo = TextInputType.text,
    this.maxLines = 1,
    this.senha = false,
    this.hint,
    this.emojiFinal,
    this.corBorda = const Color(0xFF0E2877), 
    this.corTexto = Colors.black,
    this.corLabel = const Color(0xFF0E2877),
    this.onChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: tipo,
        maxLines: senha ? 1 : maxLines,
        obscureText: senha,
        style: TextStyle(color: corTexto),
        onChanged: onChanged, 
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: corLabel),
          hintText: hint,
          suffixIcon: emojiFinal, 
          
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: corBorda, width: 2),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: corBorda, width: 3),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}