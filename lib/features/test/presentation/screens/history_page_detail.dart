import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPageDetail extends StatefulWidget {
  final String? uid;

  HistoryPageDetail({Key? key, required this.uid}) : super(key: key);

  @override
  _HistoryPageDetailState createState() => _HistoryPageDetailState();
}

class _HistoryPageDetailState extends State<HistoryPageDetail> {
  String? uid;
  int? score;
  String? timestamp;
  List<Map<String, dynamic>> answeredQuestions = [];

  @override
  void initState() {
    super.initState();
    obtenerEmpleadoPorId(widget.uid ?? "");
  }

  Future<void> obtenerEmpleadoPorId(String uid) async {
    final Uri url = Uri.parse(dotenv.env['API_URL']! + 'getDetailTest');

    final body = {
      "id": uid,
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final testResult = data['testResult'];

      setState(() {
        this.uid = data['uid'];
        this.score = testResult['score'];
        this.timestamp = testResult['timestamp'];
        this.answeredQuestions =
            List<Map<String, dynamic>>.from(testResult['answered_questions']);
      });
    } else {
      print('Error: No se pudo obtener los datos del servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Detalle del test'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/test/historial');
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              title: Text(
                'Puntuación: $score',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Century Gothic',
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Fecha y hora: $timestamp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Century Gothic',
                ),
              ),
            ),
            // Mapea las preguntas y respuestas a tarjetas para mostrarlas
            for (var question in answeredQuestions)
              Card(
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        question['question'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              'Century Gothic', // Reemplaza 'YourCustomFont' con el nombre de tu fuente personalizada
                        ),
                      ),
                    ),
                    for (var answer in question['answers'])
                      ListTile(
                        title: Text(
                          answer['text'],
                          style: TextStyle(
                            fontFamily: 'Century Gothic',
                            color: answer['isSelected'] == true
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Colors.black,
                          ),
                        ),
                        tileColor: answer['isSelected'] == true
                            ? Color.fromARGB(255, 15, 82, 149)
                            : null,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
