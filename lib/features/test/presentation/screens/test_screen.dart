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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 40),
              Image.asset('assets/renalizapp_icon.png', width: 300),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // context.go(subPath);
                  context.go('/quizz');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Cambia el color de fondo a azul
                  padding: EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20), // Aumenta el tamaño del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  '¡Realizar Test!',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors
                          .white), // Aumenta el tamaño del texto y cambia el color a blanco
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // context.go(subPath);
                  context.go('/test/login');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('¡Únete ahora!'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context.go('/test/historial');
                },
                child: Text('¿Quieres ver tu historial?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
