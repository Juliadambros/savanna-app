import 'package:flutter/material.dart';

class BotaoPadrao extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color cor;
  final double transparencia;        
  final double tamanhoFonte;
  final double largura;
  final double altura;
  final double raioBorda;
  final IconData? icone;

  const BotaoPadrao({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cor = const Color(0xFF7B1E1E),
    this.transparencia = 1.0,
    this.tamanhoFonte = 16,
    this.largura = double.infinity,
    this.altura = 50,
    this.raioBorda = 10,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largura,
      height: altura,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor.withOpacity(transparencia),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(raioBorda),
          ),
        ),
        icon: icone != null ? Icon(icone, size: tamanhoFonte + 2) : const SizedBox.shrink(),
        label: Text(
          texto,
          style: TextStyle(
            fontSize: tamanhoFonte,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
