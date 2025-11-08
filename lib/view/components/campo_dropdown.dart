import 'package:flutter/material.dart';

class CampoDropdown extends StatelessWidget {
  final String label;
  final String? valor;
  final List<String> itens;
  final Function(String?) aoMudar;

  const CampoDropdown({
    super.key,
    required this.label,
    required this.valor,
    required this.itens,
    required this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(border: OutlineInputBorder(), labelText: label),
      value: valor,
      items: itens.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: aoMudar,
    );
  }
}
