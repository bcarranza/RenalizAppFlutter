import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

//Funcion iniciar sesion Goolge
 Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          notifyListeners();
          // El usuario se ha registrado con Google correctamente
          // ignore: use_build_context_synchronously
          context.go('/test/patient-form'); // Navega a la ruta deseada
        }
      }
    } catch (error) {
      print(error);
    }
  }

//Crear cuenta com email and password Firebase
  void signUp(String email, String password) async {

    
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        notifyListeners();

    
  }

  //Iniciar sesion con correo y contraseña
  void signIn(String email, String password) async {

    
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        notifyListeners();

    
  }

  // Función para cerrar sesión
  Future<void> signOut() async {
    try {
      // Cerrar sesión con Firebase Auth
      await _auth.signOut();

      // Cerrar sesión con Google Sign-In (si se ha iniciado sesión con Google)
      await googleSignIn.signOut();

      // Notificar a los observadores que el usuario ha cerrado sesión
      notifyListeners();
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }
}
