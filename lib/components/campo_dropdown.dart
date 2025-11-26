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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField(
        value: valor,

        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF0E2877),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xFF0E2877),
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xFF0E2877),
              width: 2,
            ),
          ),
        ),

        items: itens
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            )
            .toList(),

        onChanged: aoMudar,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF0E2877),
        ),
      ),
    );
  }
}
