import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final VoidCallback? aoEditar;
  final VoidCallback? aoExcluir;

  const CardItem({
    super.key,
    required this.titulo,
    required this.subtitulo,
    this.aoEditar,
    this.aoExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (aoEditar != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: aoEditar,
              ),
            if (aoExcluir != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: aoExcluir,
              ),
          ],
        ),
      ),
    );
  }
}
