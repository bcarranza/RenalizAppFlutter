import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  DateTime? selectedDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '150217668394-6s05qjtj3rli7ksgsdm14nggbe93nfcp.apps.googleusercontent.com',
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('es', 'ES'),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
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
          // El usuario se ha registrado con Google correctamente
          _navigatorKey.currentState!.pushNamed('/test/patient-file');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _signOut() async {
    try {
      // Cerrar sesión con Firebase
      await _auth.signOut();

      // Cerrar sesión con Google
      await googleSignIn.signOut();

      print("Sesión cerrada exitosamente");
    } catch (error) {
      print("Error al cerrar sesión: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Paciente'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  child: Image.asset('assets/renalizapp_icon.png'),
                ),
                SizedBox(height: 10),
                Container(
                  width: 400,
                  child: Column(
                    children: [
                      _buildTextField('Nombres', (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese los nombres';
                        }
                        return null;
                      }),
                      _buildTextField('Correo', (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese el correo';
                        }
                        if (!_isValidEmail(value)) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      }),
                      _buildTextField('Contraseña', (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese la contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      }, isPassword: true),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            selectedDate != null
                                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                : "Seleccione una fecha",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      _buildTextField('Dirección', (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese la dirección';
                        }
                        return null;
                      }),
                      _buildTextField('Teléfono', (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese el teléfono';
                        }
                        return null;
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GoogleAuthButton(
                  onPressed: () async {
                    await _signInWithGoogle();
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform form submission
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Guardar datos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, String? Function(String?)? validator,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        validator: validator,
        obscureText:
            isPassword, // Utiliza obscureText para ocultar la contraseña
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Nunito',
        ),
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }
}
