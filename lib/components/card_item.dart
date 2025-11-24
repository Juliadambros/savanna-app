import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String imagem; // Caminho da imagem
  final VoidCallback? onTap;

  const CardItem({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.imagem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagem,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1a1a1a),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              descricao,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff444444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
