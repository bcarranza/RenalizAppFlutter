import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';

import '../../../shared/infrastructure/provider/auth_provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({required this.subPath, Key? key}) : super(key: key);

  final String subPath;
   final String dialogPrefKey = 'termsDialogShown'; 
   final String dialogPrefUserKey = 'termsUserDialogShown'; 


  Future<void> _showTermsDialog(BuildContext context, String  title, String  textDialog ,  String path , String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dialogShown = prefs.getBool(key) ?? false;

    if (!dialogShown) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(title),
            content:  SingleChildScrollView(
              child: Text(textDialog),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  prefs.setBool(dialogPrefKey, true);
                  Navigator.of(context).pop();
                  context.go(path);
                },
              ),
            ],
          );
        },
      );
    } else {
      context.go('/test/quizz');
    }
  }
   

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 40),
            Image.asset('assets/renalizapp_icon.png', width: 300),
            const SizedBox(height: 20),
            authProvider.currentUser != null
                ? ElevatedButton(
                    onPressed: () {
                    _showTermsDialog(
                      context,
                      "Términos de privacidad",
                      "Toda la información que será recolectada tendrá uso únicamente informativo a las entidades médicas de Jalapa. En ningún momento RenalizApp guardará la información personal para otros fines y toda información solicitada es únicamente para poder dar un diagnóstico aún más preciso.",
                      "/test/quizz",
                      dialogPrefKey
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '¡Realizar test!',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            authProvider.currentUser == null
                ? ElevatedButton(
                    onPressed: () {
                      _showTermsDialog(
                      context,
                      "Términos de privacidad para cuentas",
                      "Toda la información que será recolectada tendrá uso únicamente informativo a las entidades médicas de Jalapa. En ningún momento RenalizApp guardará la información personal para otros fines y toda información solicitada es únicamente para poder dar un diagnóstico aún más preciso.",
                      "/login",
                      dialogPrefUserKey
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('¡Únete ahora!'),
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.go('/test/historial');
              },
              child: const Text('¿Quieres ver tu historial?'),
            ),
          ],
        ),
      )),
    );
  }
}
