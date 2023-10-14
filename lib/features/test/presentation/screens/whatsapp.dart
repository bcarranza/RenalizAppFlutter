import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class WhatsAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    String? username=authProvider.currentUser?.displayName;
    String? iduser=authProvider.currentUser?.uid;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¡Hola! ¿Tienes alguna pregunta sobre la app? Estamos aquí para ayudarte. También puedes colaborar con nosotros enviando tus comprobantes de creatinina como un pre diagnóstico para pacientes renales. (No es necesario entregar los resultados, solo un comprobante) ¡Tu apoyo es valioso!',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                openWhatsApp(context, iduser, username);
              },
              child: Text('Abrir WhatsApp'),
            ),
          
            ElevatedButton(
              onPressed: () {
                openWhatsAppWeb(iduser, username);
              },
              child: Text('Abrir WhatsApp Web'),
            ),
          ],
        ),
      ),
    );
  }

  void openWhatsApp(BuildContext context, String? iduser, String? username) async {
    var whatsapp = "+50240515851";
    var message = Uri.encodeComponent(
        "Hola Renalizapp, Soy el Usuario id: $iduser  , nombre: $username ; adjunto el comprobante de exámen para colaborar con la comprobación de su hipótesis.");
    
    if (Platform.isIOS) {
      final whatsappURL = Uri.parse("https://wa.me/$whatsapp?text=$message");
      if (await canLaunchUrl(whatsappURL)) {
        await launchUrl(whatsappURL);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("WhatsApp no está instalado."),
        ));
      }
    } else {
      final whatsappURL = Uri.parse("whatsapp://send?phone=$whatsapp&text=$message");
      if (await canLaunchUrl(whatsappURL)) {
        await launchUrl(whatsappURL);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("WhatsApp no está instalado."),
        ));
      }
    }
  }

  void openWhatsAppWeb(String? iduser, String? username) {
    final phoneNumber = "+50240515851";
    final message = "Hola Renalizapp, Soy el Usuario id: $iduser , nombre: $username ; adjunto el comprobante de exámen para colaborar con la comprobación de su hipótesis.";
    final url = Uri.parse('https://web.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}');
    launchUrl(url); // Abre el enlace en el navegador web
  }
}




