import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PatientForm extends StatefulWidget {
  final GoRouter appRouter;

  PatientForm({required this.appRouter});

  @override
  _PatientFormState createState() => _PatientFormState();
}

class PatientFormData {
  String? firstName;
  String? secondName;
  String? firstLastName;
  String? secondLastName;
  DateTime? dob;
  String? cui;
  String? phoneNumber;
  String? email;
  String? address;
  String? city;
  String? department;
  String? bloodType;
  String? maritalStatus;
  String? gender;
}

class _PatientFormState extends State<PatientForm> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  String? selectedDepartment;

  final GlobalKey<FormState> _formKeyPage1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPage2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPage3 = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  PatientFormData _formData = PatientFormData();

  @override
  void initState() {
    super.initState();

    // Obtener el usuario actualmente autenticado
    final user = FirebaseAuth.instance.currentUser;

    // Verificar si el usuario tiene un correo electrónico
    if (user != null && user.email != null) {
      setState(() {
        _formData.email = user.email;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('es', 'ES'),
    );

    if (picked != null && picked != _formData.dob) {
      setState(() {
        _formData.dob = picked;
      });
    }
  }

  Future<int> postRegisterData(Map<String, dynamic> body) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final idTokenResult = await user?.getIdTokenResult();
      final token = idTokenResult?.token;

      final Uri uri = Uri.parse(dotenv.env['API_URL']! + 'postRegister');

      final response = await http.post(uri, body: body);

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        // Puedes manejar el error aquí si lo deseas, por ejemplo, imprimir los valores del cuerpo (body).
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Maneja cualquier excepción que pueda ocurrir durante la solicitud
      print('Error: $e');
      throw e;
    }
  }

  void _nextPage() {
    // Realizar validación antes de avanzar a la siguiente página
    if (_currentPage == 0) {
      if (_formKeyPage1.currentState!.validate()) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    } else if (_currentPage == 1) {
      if (_formKeyPage2.currentState!.validate()) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    } else {
      // Página 2
      if (_formKeyPage3.currentState!.validate()) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  String? _validateText(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Ingrese el $fieldName';
    }
    return null;
  }

  String? _validateDate(DateTime? value) {
    if (value == null) {
      return 'Seleccione una fecha de nacimiento';
    }
    return null;
  }

  void _submitForm() async {
    bool isValid = true;
    if (_currentPage == 0) {
      isValid = _formKeyPage1.currentState!.validate();
    } else if (_currentPage == 1) {
      isValid = _formKeyPage2.currentState!.validate();
    } else {
      isValid = _formKeyPage3.currentState!.validate();
    }

    if (isValid) {
      final user = FirebaseAuth.instance.currentUser;
      final body = {
        "uid": user?.uid.toString(),
        "First_Name": _formData.firstName,
        "Second_Name": _formData.secondName ?? "",
        "Last_Name": _formData.firstLastName,
        "Second_Last_Name": _formData.secondLastName ?? "",
        "Birth_Date": _formData.dob.toString(),
        "DPI": _formData.cui,
        "Telephone_Number": _formData.phoneNumber,
        "Email": _formData.email ?? "",
        "Address": _formData.address ?? "",
        "Department": selectedDepartment,
        "City": _formData.city,
        "Blood_Type": _formData.bloodType ?? "",
        "Civil_Status": _formData.maritalStatus ?? "",
        "Gender": _formData.gender ?? "",
      };

      try {
        final responseCode = await postRegisterData(body);

        if (responseCode == 201) {
          widget.appRouter.go('/profile');
        } else {
          print('Error en la solicitud POST: $responseCode');
        }
      } catch (e) {
        print('Error en la solicitud POST: $e');
      }
    }
  }

  Widget _buildNextButton() {
    if (_currentPage < 2) {
      return ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Color de fondo
          foregroundColor: Colors.white, // Color del texto
          padding: EdgeInsets.symmetric(
              vertical: 16, horizontal: 32), // Aumentar el tamaño
        ),
        child: Text(
          'Siguiente',
          style: TextStyle(fontSize: 18), // Aumentar el tamaño del texto
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Color de fondo
          foregroundColor: Colors.white, // Color del texto
          padding: EdgeInsets.symmetric(
              vertical: 16, horizontal: 32), // Aumentar el tamaño
        ),
        child: Text(
          'Enviar',
          style: TextStyle(fontSize: 18), // Aumentar el tamaño del texto
        ),
      );
    }
  }

  Widget _buildBackButton() {
    if (_currentPage > 0) {
      return ElevatedButton(
        onPressed: _previousPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Color de fondo
          foregroundColor: Colors.white, // Color del texto
          padding: EdgeInsets.symmetric(
              vertical: 16, horizontal: 32), // Aumentar el tamaño
        ),
        child: Text(
          'Atrás',
          style: TextStyle(fontSize: 18), // Aumentar el tamaño del texto
        ),
      );
    } else {
      // En la primera página, el botón de "Atrás" no debe estar habilitado.
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey, // Color de fondo
          foregroundColor: Colors.white, // Color del texto
          padding: EdgeInsets.symmetric(
              vertical: 16, horizontal: 32), // Aumentar el tamaño
        ),
        child: Text(
          'Atrás',
          style: TextStyle(fontSize: 18), // Aumentar el tamaño del texto
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Registro de Paciente'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/renalizapp_icon.png', width: 150),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  SingleChildScrollView(
                    child: _buildPage1(),
                  ),
                  SingleChildScrollView(
                    child: _buildPage2(),
                  ),
                  SingleChildScrollView(
                    child: _buildPage3(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: _currentPage < 2
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    child: Text(
                      'Atrás',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                if (_currentPage < 2)
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    child: Text(
                      'Siguiente',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                if (_currentPage == 2)
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    child: Text(
                      'Enviar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyPage1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.firstName = value;
                });
              },
              initialValue: _formData.firstName,
              decoration: InputDecoration(
                labelText: 'Primer Nombre (obligatorio)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateText(value, 'primer nombre'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.secondName = value;
                });
              },
              initialValue: _formData.secondName,
              decoration: InputDecoration(
                labelText: 'Segundo Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.firstLastName = value;
                });
              },
              initialValue: _formData.firstLastName,
              decoration: InputDecoration(
                labelText: 'Primer Apellido (obligatorio)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateText(value, 'primer apellido'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.secondLastName = value;
                });
              },
              initialValue: _formData.secondLastName,
              decoration: InputDecoration(
                labelText: 'Segundo Apellido',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyPage2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento (obligatorio)',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _formData.dob != null
                      ? "${_formData.dob!.day}/${_formData.dob!.month}/${_formData.dob!.year}"
                      : "Seleccione una fecha",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.cui = value;
                });
              },
              initialValue: _formData.cui,
              decoration: InputDecoration(
                labelText: 'CUI (obligatorio)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateText(value, 'CUI'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.phoneNumber = value;
                });
              },
              initialValue: _formData.phoneNumber,
              decoration: InputDecoration(
                labelText: 'Número de Teléfono (obligatorio)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateText(value, 'número de teléfono'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.email = value;
                });
              },
              initialValue: _formData.email,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyPage3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  _formData.address = value;
                });
              },
              initialValue: _formData.address,
              decoration: InputDecoration(
                labelText: 'Dirección (obligatorio)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateText(value, 'dirección'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              items: departmentsData.map((Department department) {
                return DropdownMenuItem<String>(
                  value: department.title,
                  child: Text(department.title),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedDepartment = value;
                  // Limpia la selección de la ciudad al cambiar el departamento
                  _formData.city = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Departamento (obligatorio)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateText(value, 'departamento'),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _formData.city,
              items: selectedDepartment != null
                  ? departmentsData
                      .firstWhere((department) =>
                          department.title == selectedDepartment)
                      .mun
                      .map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList()
                  : [],
              onChanged: (String? value) {
                setState(() {
                  _formData.city = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Ciudad (obligatorio)',
                border: OutlineInputBorder(),
              ),
              validator: (value) => _validateText(value, 'ciudad'),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _formData.bloodType,
              items: [
                "A+",
                "A-",
                "B+",
                "B-",
                "AB+",
                "AB-",
                "O+",
                "O-",
              ].map((String bloodType) {
                return DropdownMenuItem<String>(
                  value: bloodType,
                  child: Text(bloodType),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _formData.bloodType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Sangre',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _formData.maritalStatus,
              items: [
                "Soltero/a",
                "Casado/a",
                "Divorciado/a",
                "Viudo/a",
              ].map((String maritalStatus) {
                return DropdownMenuItem<String>(
                  value: maritalStatus,
                  child: Text(maritalStatus),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _formData.maritalStatus = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Estado Civil',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _formData.gender,
              items: [
                "Masculino",
                "Femenino",
                "Prefiero no decirlo",
              ].map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _formData.gender = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Género',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
