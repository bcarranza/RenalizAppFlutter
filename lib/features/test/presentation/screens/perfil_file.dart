import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';
import 'package:renalizapp/features/shared/widgets/navigation/appBar/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';

class PerfilFile extends StatefulWidget {
  @override
  _PerfilFileState createState() => _PerfilFileState();
}

class _PerfilFileState extends State<PerfilFile> {
  Future<Map<String, dynamic>> getUserData(String uid) async {
    final url =
        'https://us-central1-renalizapp-dev-2023-396503.cloudfunctions.net/renalizapp-2023-dev-getUserByUid';

    final body = {
      "uid": uid,
    };

    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return userData;
    } else {
      throw Exception('Error al obtener los datos del usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    String? userName = authProvider.currentUser?.displayName;
    String? userPhoto = authProvider.currentUser?.photoURL;

    ImageProvider<Object>? backgroundImage;

    if (userPhoto != null) {
      backgroundImage = NetworkImage(userPhoto);
    } else {
      backgroundImage = AssetImage('assets/renalizapp_icon.png');
    }

    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Agregamos SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (authProvider.currentUser == null)
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
                          context.go('/test/login');
                        },
                        child: Text("Inicia sesión ahora"),
                      ),
                    ],
                  ),
                if (authProvider.currentUser != null)
                  FutureBuilder(
                    future: getUserData(authProvider.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final userData = snapshot.data as Map<String, dynamic>;
                        final user = userData['user'] as Map<String, dynamic>;
                        print(user);
                        // Verificar si los campos son nulos antes de acceder a ellos
                        String userFirstName = user['First_Name'] ?? '';
                        String userLastName = user['Last_Name'] ?? '';
                        String userSecondLastName =
                            user['Second_Last_Name'] ?? '';
                        String userBirthDate = user['Birth_Date'] ?? '';
                        String documentType = user['DPI'] ?? '';
                        String telephoneNumber = user['Telephone_Number'] ?? '';
                        String email = user['Email'] ?? '';
                        String userAddress = user['Address'] ?? '';
                        String department = user['Department'] ?? '';
                        String userCity = user['City'] ?? '';
                        String bloodType = user['Blood_Type'] ?? '';
                        String civilStatus = user['Civil_Status'] ?? '';
                        String gender = user['Gender'] ?? '';
                        return Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 400),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      backgroundImage as ImageProvider,
                                  radius: 50,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '¡Hola, $userFirstName $userLastName!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                _buildProfileInfo(Icons.calendar_today,
                                    'Fecha de Nacimiento', userBirthDate),
                                _buildProfileInfo(Icons.perm_identity,
                                    'Tipo de Documento', documentType),
                                _buildProfileInfo(
                                    Icons.phone, 'Teléfono', telephoneNumber),
                                _buildProfileInfo(Icons.email, 'Email', email),
                                _buildProfileInfo(Icons.location_on,
                                    'Dirección', userAddress),
                                _buildProfileInfo(
                                    Icons.location_city, 'Ciudad', userCity),
                                _buildProfileInfo(
                                    Icons.business, 'Departamento', department),
                                _buildProfileInfo(Icons.bloodtype,
                                    'Tipo de Sangre', bloodType),
                                _buildProfileInfo(
                                    Icons.people, 'Estado Civil', civilStatus),
                                _buildProfileInfo(
                                    Icons.person, 'Género', gender),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
    );
  }
}
