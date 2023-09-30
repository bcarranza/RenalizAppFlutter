import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';

class PerfilFile extends StatefulWidget {
  @override
  _PerfilFileState createState() => _PerfilFileState();
}

class _PerfilFileState extends State<PerfilFile> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actualmente autenticado
   final authProvider = Provider.of<AuthProvider>(context);

    // Obtener el nombre del usuario (puedes personalizar esto según tu sistema de autenticación)
    String? userName = authProvider.currentUser?.displayName;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (authProvider.currentUser == null) // Conditionally show the message and login button
              Column(
                children: [
                  Text(
                    "Parece que no has iniciado sesión",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the login screen when the button is pressed
                      context.go('/test/login');
                    },
                    child: Text("Inicia sesión ahora"),
                  ),
                ],
              ),
            if (authProvider.currentUser != null) // Show welcome message for authenticated users
              Text(
                'Bienvenido, $userName', // Display the user's name if available
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            // Additional content for your profile screen
          ],
        ),
      ),
    );
  }
}
