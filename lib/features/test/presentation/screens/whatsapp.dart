import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; 

class WhatsAppScreen extends StatelessWidget {
  const WhatsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    String? username = authProvider.currentUser?.displayName;
    String? iduser = authProvider.currentUser?.uid;


    bool isWeb = kIsWeb;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '¡Hola! ¿Tienes alguna pregunta sobre la app? Estamos aquí para ayudarte. También puedes colaborar con nosotros enviando tus comprobantes de creatinina como un pre diagnóstico para pacientes renales. (No es necesario entregar los resultados, solo un comprobante) ¡Tu apoyo es valioso!',
              textAlign: TextAlign.center,
            ),
            if (!isWeb)
              ElevatedButton(
                onPressed: () {
                  openWhatsApp(context, iduser, username);
                },
                child: const Text('Abrir WhatsApp'),
              ),
            if (isWeb)
              ElevatedButton(
                onPressed: () {
                  openWhatsAppWeb(iduser, username);
                },
                child: const Text('Abrir WhatsApp Web'),
              ),
          ],
        ),
      ),
    );
  }

  void openWhatsApp(BuildContext context, String? iduser, String? username) async {
    var whatsapp = "+50249192039";
    var message = Uri.encodeComponent(
        "Hola Renalizapp, Soy el Usuario id: $iduser  , nombre: $username ; adjunto el comprobante de exámen para colaborar con la comprobación de su hipótesis.");
    
    if (Platform.isIOS) {
      final whatsappURL = Uri.parse("https://wa.me/$whatsapp?text=$message");
      if (await canLaunchUrl(whatsappURL)) {
        await launchUrl(whatsappURL);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("WhatsApp no está instalado."),
        ));
      }
    } else {
      final whatsappURL = Uri.parse("whatsapp://send?phone=$whatsapp&text=$message");
      await launchUrl(whatsappURL);
    }
  }

  void openWhatsAppWeb(String? iduser, String? username) {
    const phoneNumber = "+50249192039";
    final message = "Hola Renalizapp, Soy el Usuario id: $iduser , nombre: $username ; adjunto el comprobante de exámen para colaborar con la comprobación de su hipótesis.";
    final url = Uri.parse('https://web.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}');
    launchUrl(url); // Abre el enlace en el navegador web
  }
}
