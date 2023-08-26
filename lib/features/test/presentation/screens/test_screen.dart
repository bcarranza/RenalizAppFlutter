import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/test/presentation/screens/patient_form.dart';

class TestScreen extends StatelessWidget {
  /// Creates a RootScreen
  const TestScreen({required this.subPath, Key? key}) : super(key: key);

  /// The label

  /// The path to the detail page
  final String subPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renalizapp'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¡Haz culminado tu test!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Image.asset('assets/renalizapp_icon.png', width: 300),
                  Center(
                    child: Text(
                      '¿Deseas formar parte de la \n comunidad?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PatientForm()),
                      );
                    },
                    child: Text('Registrarse'),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.go(subPath),
              child: const Text('Moverse a ruta hija'),
            ),
          ],
        ),
      ),
    );
  }
}
