import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class PatientForm extends StatefulWidget {
  final GoRouter appRouter;

  PatientForm({required this.appRouter});
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  DateTime? selectedDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // Define los controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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

  Future<int> _httpsCall() async {
    final user = FirebaseAuth.instance.currentUser;

    final idTokenResult = await user?.getIdTokenResult();
    final token = idTokenResult?.token;

    Uri uri = Uri.parse(
        'https://us-central1-renalizapp-2023.cloudfunctions.net/renalizapp-2023-prod-postRegister');

    final body = {
      'name': _nameController.text,
      'dob': selectedDate.toString(),
      'address': _addressController.text,
      'phoneNumber': _phoneNumberController.text,
      'uid': user?.uid.toString(),
    };
    final response = await http.post(uri, body: body);

    if (response.statusCode == 201) {
      return response.statusCode;
    } else {
      print(_nameController.text);
      print(selectedDate.toString());
      print(_addressController.text);
      print(_phoneNumberController.text);
      throw Exception('Error: ${response.statusCode}');
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
                      }, controller: _nameController), // Asigna _nameController
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
                      },
                          controller:
                              _addressController), // Asigna _addressController
                      _buildTextField('Teléfono', (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese el teléfono';
                        }
                        return null;
                      },
                          controller:
                              _phoneNumberController), // Asigna _phoneNumberController
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final responseCode = await _httpsCall();
                        if (responseCode == 201) {
                          // Procesa la respuesta exitosa aquí
                          // Por ejemplo, puedes redirigir al usuario a una página de éxito
                          // o mostrar un mensaje de éxito.
                          widget.appRouter.go('/profile');
                        } else {
                          // Mostrar un mensaje de error al usuario
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al enviar el formulario. Por favor, inténtelo de nuevo. Detalles del error: $responseCode',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        // Manejo de errores
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error al enviar el formulario. Por favor, inténtelo de nuevo.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Completar perfil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    String? Function(String?)? validator, {
    required TextEditingController controller, // Agrega el parámetro controller
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller, // Asigna el controlador al campo de texto
        validator: validator,
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
}
