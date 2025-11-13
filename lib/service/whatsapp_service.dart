import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> enviarMensagem(String numero, String mensagem) async {
    if (numero.isEmpty) {
      throw 'Número de telefone inválido';
    }

    final formatado = numero.replaceAll('+', '').replaceAll(' ', '');
    final uri = Uri.parse(
      'https://wa.me/$formatado?text=${Uri.encodeComponent(mensagem)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o WhatsApp.';
    }
  }
}

