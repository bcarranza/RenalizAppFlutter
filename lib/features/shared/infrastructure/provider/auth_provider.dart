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
        final AdditionalUserInfo? additionalUserInfo =
            authResult.additionalUserInfo;

        if (user != null) {
          // Verificar si el usuario es nuevo o no
          if (additionalUserInfo?.isNewUser == true) {
            // El usuario es nuevo, llévalo a la pantalla de registro de paciente
            notifyListeners();
            context.go(
                '/test/patient-form'); // Cambia '/test/patient-form' por la ruta correcta del formulario de paciente
          } else {
            // El usuario no es nuevo, llévalo a la pantalla de perfil
            notifyListeners();
            context.pop(); // Cambia '/profile' por la ruta correcta de perfil
          }
        }
      }
    } catch (error) {
     
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
    }
  }
}
