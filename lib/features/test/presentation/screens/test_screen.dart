import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/test/presentation/screens/patient_form.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({required this.subPath, Key? key}) : super(key: key);

  final String subPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renalizapp'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                '¡Haz culminado tu test!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/renalizapp_icon.png', width: 300),
              const SizedBox(height: 20),
              Text(
                '¿Deseas formar parte de la \n comunidad?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(subPath);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Registrarse'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Redirige a la subruta de inicio de sesión
                  context.go('/test/login');
                },
                child: Text(
                    '¿Ya tienes una cuenta? Iniciar sesión'), // Cambia el texto según tus necesidades
              )
            ],
          ),
        ),
      ),
    );
  }
}
