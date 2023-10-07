import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HistoryPage extends StatefulWidget {
  final GoRouter appRouter;

  HistoryPage({required this.appRouter});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> history = [];
  bool _isLoading = true;  // Variable para rastrear si los datos están cargando

  // Carga el historial desde SharedPreferences
  Future<void> loadHistory() async {
    final authProvider = context.read<AuthProvider>();
    String? uid = authProvider.currentUser?.uid;
    //print(uid);

    if (uid != null) {
      // Usuario ha iniciado sesión
      final Uri uri = Uri.parse(dotenv.env['API_URL']! + 'getTestsByUid');
      final response = await http.post(
        uri,
        body: json.encode({'uid': uid}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String formattedResult = data['formattedResult'];
        //print(formattedResult);

        // Dividir formattedResult en una lista de cadenas
        final List<String> historyItems = formattedResult.split(', ');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('history', historyItems);

        setState(() {
          history = historyItems;
          _isLoading = false;  // Datos cargados, establecer _isLoading a false
        });
        //print(prefs);
      } else {
        // Manejar error en la respuesta
        setState(() {
          _isLoading = false;  // Error en la respuesta, establecer _isLoading a false
        });
      }
    } else {
      //print("NO se ha iniciado sesion");
      // Usuario no ha iniciado sesión
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedHistory = prefs.getStringList('history');
      if (savedHistory != null) {
        setState(() {
          history = savedHistory;
          _isLoading = false;  // Datos cargados, establecer _isLoading a false
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadHistory();  // Carga el historial cuando se inicia la página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial de Puntuaciones"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),  // Icono de flecha hacia atrás
          onPressed: () {
            // Navega de regreso a la pantalla anterior
            widget.appRouter.pop();
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())  // Muestra el indicador de carga si _isLoading es true
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                // Divide la cadena almacenada en SharedPreferences
                final data = history[index].split(';');
                if (data.length == 4) {
                  final score = data[0];
                  final resultMessage = data[1];
                  final resultDescription = data[2];
                  final testDate = data[3];

                  return Card(
                    elevation: 3,  // Sombra ligera
                    margin: EdgeInsets.all(8),  // Margen alrededor de cada tarjeta
                    child: ListTile(
                      title: Text(
                        "Puntuación: $score",
                        style: TextStyle(
                          fontSize: 16,  // Tamaño de fuente personalizado
                          fontWeight: FontWeight.bold,  // Tipo de letra en negrita
                          fontFamily: 'Roboto',  // Cambia esto según tus preferencias
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Resultado: $resultMessage",
                            style: TextStyle(
                              fontSize: 14,  // Tamaño de fuente personalizado
                              fontFamily: 'Roboto',  // Cambia esto según tus preferencias
                            ),
                          ),
                          Text(
                            "Descripción: $resultDescription",
                            style: TextStyle(
                              fontSize: 14,  // Tamaño de fuente personalizado
                              fontFamily: 'Roboto',  // Cambia esto según tus preferencias
                            ),
                          ),
                          Text(
                            "Fecha de la prueba: $testDate",
                            style: TextStyle(
                              fontSize: 14,  // Tamaño de fuente personalizado
                              fontFamily: 'Roboto',  // Cambia esto según tus preferencias
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();  // Opcional: Manejar datos incorrectos
              },
            ),
    );
  }
}