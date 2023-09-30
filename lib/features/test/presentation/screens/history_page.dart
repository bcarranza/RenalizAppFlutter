import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final GoRouter appRouter;

  HistoryPage({required this.appRouter});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> history = [];

  // Carga el historial desde SharedPreferences
  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedHistory = prefs.getStringList('history');
    if (savedHistory != null) {
      setState(() {
        history = savedHistory;
      });
    }
    print('Historial cargado: $history'); // Agregar este print
  }

  @override
  void initState() {
    super.initState();
    loadHistory(); // Carga el historial cuando se inicia la página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial de Puntuaciones"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            // Navega de regreso a la pantalla anterior
            widget.appRouter.pop();
          },
        ),
      ),
      body: ListView.builder(
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
              elevation: 3, // Sombra ligera
              margin: EdgeInsets.all(8), // Margen alrededor de cada tarjeta
              child: ListTile(
                title: Text(
                  "Puntuación: $score",
                  style: TextStyle(
                    fontSize: 16, // Tamaño de fuente personalizado
                    fontWeight: FontWeight.bold, // Tipo de letra en negrita
                    // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                    fontFamily: 'Roboto', // Cambia esto según tus preferencias
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Resultado: $resultMessage",
                      style: TextStyle(
                        fontSize: 14, // Tamaño de fuente personalizado
                        // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                        fontFamily:
                            'Roboto', // Cambia esto según tus preferencias
                      ),
                    ),
                    Text(
                      "Descripción: $resultDescription",
                      style: TextStyle(
                        fontSize: 14, // Tamaño de fuente personalizado
                        // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                        fontFamily:
                            'Roboto', // Cambia esto según tus preferencias
                      ),
                    ),
                    Text(
                      "Fecha de la prueba: $testDate",
                      style: TextStyle(
                        fontSize: 14, // Tamaño de fuente personalizado
                        // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                        fontFamily:
                            'Roboto', // Cambia esto según tus preferencias
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container(); // Opcional: Manejar datos incorrectos
        },
      ),
    );
  }
}
