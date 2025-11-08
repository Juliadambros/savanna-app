import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<void> enviarMensagem(String numeroComDDI, String mensagem) async {
    final encoded = Uri.encodeComponent(mensagem);
    final url = 'https://wa.me/$numeroComDDI?text=$encoded';
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Não foi possível abrir o WhatsApp';
    }
  }
}
