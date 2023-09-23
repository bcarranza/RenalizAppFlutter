import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PerfilFile extends StatefulWidget {
  @override
  _PerfilFileState createState() => _PerfilFileState();
}

class _PerfilFileState extends State<PerfilFile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Función para cerrar sesión
  void _signOut() async {
    try {
      // Cerrar sesión con Firebase Auth
      await _auth.signOut();

      // Cerrar sesión con Google Sign-In (si se ha iniciado sesión con Google)
      await googleSignIn.signOut();

      // Luego, puedes navegar de vuelta a la pantalla de inicio de sesión o a donde desees
      GoRouter.of(context)
          .go('/test'); // Asegúrate de que la ruta sea la correcta
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario actualmente autenticado
    User? user = _auth.currentUser;

    // Obtener el nombre del usuario (puedes personalizar esto según tu sistema de autenticación)
    String? userName = user?.displayName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar un mensaje de bienvenida con el nombre del usuario
            Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Contenido adicional de tu pantalla de perfil
          ],
        ),
      ),
    );
  }
}