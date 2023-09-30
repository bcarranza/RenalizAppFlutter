import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';
import 'package:renalizapp/features/test/presentation/screens/patient_form.dart';

import '../../../shared/infrastructure/provider/auth_provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({required this.subPath, Key? key}) : super(key: key);

  final String subPath;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Image.asset('assets/renalizapp_icon.png', width: 300),
              const SizedBox(height: 20),
              Text(
                '¿Deseas formar parte de la \n comunidad?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              authProvider.currentUser == null
                  ? ElevatedButton(
                      onPressed: () {
                        context.go('/test/login');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('¡Únete ahora!'),
                    )
                  : SizedBox(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // context.go(subPath);
                  context.go('/quizz');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('¡Realizar Test!'),
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
